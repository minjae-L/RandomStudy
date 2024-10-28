//
//  FirebaseDatabase.swift
//  RandomStudy
//
//  Created by 이민재 on 5/23/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class FirebaseManager {
    private let db = Firestore.firestore()
    static let shared = FirebaseManager()
    private let tableNames = ["study", "todo", "history"]
    private let column = ["name", "done", "date"]
    private var uid: String
    var elements = [FirebaseDataModel]()
    init () {
        print("FirebaseManager init")
        self.uid = Auth.auth().currentUser?.uid ?? ""
    }
    
    func getFilteredData(type: DataModelType) -> [FirebaseDataModel] {
        switch type {
        case .todo:
            return elements.filter{$0.date == nil && $0.done == nil }
        case .today:
            return elements.filter{$0.date == nil && $0.done != nil }
        case .history:
            return elements.filter{$0.date != nil && $0.done != nil }
        }
    }
//    MARK: Method
    // 내부DB에 데이터가 존재하는지 확인하는 함수
    func isDataExist() -> Bool{
        for i in tableNames {
            let data = DBHelper.shared.readData(tableName: i, column:  column)
            if !data.isEmpty { return true }
        }
        return false
    }
    func fetchData() {
        print("firebaseManager fetchData")
        self.getDataFromFirebase() { [weak self] data in
            self?.elements = data ?? []
        }
    }
    // Firebase로부터 데이터 불러오기
    private func getDataFromFirebase(completion: @escaping ([FirebaseDataModel]?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            if let error = error as? NSError {
                print(error.localizedDescription)
                completion(nil)
                return
            }
            if snapshot!.documents.isEmpty {
                print("Firebase:: getDataFromFirebase:: Empty Documents")
                completion([])
                return
            }
            guard let filtered = snapshot?.documents[0].data().filter({ (key: String, value: Any) in
                if key == "data" { return true }
                return false
            }) else { return }
            
            do {
                let jsonFile = try JSONSerialization.data(withJSONObject: filtered)
                let data = try JSONDecoder().decode([String: [FirebaseDataModel]].self, from: jsonFile)
                let converted = Array(data.values).flatMap{$0}
                completion(converted)
                print("Firebase:: getDataFromFirebase:: receive Data Successful")
            } catch {
                print("Firebase:: getDataFromFirebase:: receive Data Fail")
            }
        }
    }
    // 데이터 쓰기
    func setDataToFirebase(data: FirebaseDataModel) {
        self.elements.append(data)
        do {
            let encoded = try Firestore.Encoder().encode(data)
            db.collection("users").document(uid).updateData(["data": FieldValue.arrayUnion([encoded])])
            print("FirebaseManager:: Set Data to Firebase")
        } catch {
            print("fail")
        }
        print("elements: \(self.elements)")
    }
    // 데이터 지우기
    func removeDataFromFirebase(data: FirebaseDataModel) {
        for i in 0..<elements.count {
            if elements[i].done == nil || elements[i].date != nil {
                continue
            }
            if data.name == elements[i].name {
                print("removed: \(elements[i])")
                self.elements.remove(at: i)
                break
            }
        }
        do {
            let encoded = try Firestore.Encoder().encode(data)
            db.collection("users").document(uid).updateData(["data": FieldValue.arrayRemove([encoded])])
            print("FirebaseManager:: Delete Data From Firebase")
        } catch {
            print("FirebaseManager:: Fail!! Delete Data From Firebase")
        }
    }
    // 모든 데이터 지우기
    func removeAllData() {
        self.elements.removeAll()
        db.collection("users").document(uid).updateData(["data": FieldValue.delete()])
        print("FirebaseManager:: All Data Removed")
    }
    // 로그인
    func login(email: String, password: String, completion: @escaping (Bool, String) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password) { AuthDataResult, error in	
            if let error = error {
                print("Login Fail")
                let authError = error as NSError
                if let ac = AuthErrorCode.Code(rawValue: authError.code) {
                    switch ac {
                    case .wrongPassword:
                        completion(false, "비밀번호가 일치하지 않습니다.")
                    case .invalidEmail:
                        completion(false, "이메일 형식이 올바르지 않습니다.")
                    case .userDisabled:
                        completion(false, "이 계정은 현재 사용중지 상태입니다.")
                    case .operationNotAllowed:
                        completion(false, "현재 이메일 로그인을 지원하지 않습니다.")
                    default:
                        completion(false, "로그인 실패\n이메일과 비밀번호를 확인해주세요.")
                    }
                }
            } else {
                print("Login Success")
                completion(true, "")
            }
        }
    }
    // uid문서 생성
    func makeFirebaeDocument() {
        db.collection("users").document(self.uid).getDocument { [weak self] snapshot, error in
            guard let self = self else { return }
            if error != nil {
                let error = error?.localizedDescription
                print("FirebaseManager:: makeFirebaseDocument Error: \(String(describing: error))")
                return
            }
            if snapshot?.data() == nil {
                db.collection("users").document(self.uid).setData(["uid": self.uid])
                print("FirebaseManager:: makeFirebaseDocument Success")
            }
        }
    }
}

// MARK: Data Migration
extension FirebaseManager {
    // 데이터 마이그레이션
    func dataMigration() {
        print("Firebase:: dataMigration:: Excuted")
        Firestore.firestore().collection("users").document(uid).updateData(["data": FieldValue.arrayUnion(getDataFromSQLite())])
        DBHelper.shared.resetAllTable()
    }
    // 마이그레이션 전에 SQLite로부터 데이터 불러오기
    func getDataFromSQLite() -> [[String: Any]]{
        var dataArray = [[String: Any]]()
        var data = DBHelper.shared.readData(tableName: "todo", column: column)
        
        if !data.isEmpty {
            for j in data {
                dataArray.append(["name": j.name!])
            }
        }
        
        data = DBHelper.shared.readData(tableName: "study", column: column)
        if !data.isEmpty {
            for j in data {
                dataArray.append(["name": j.name!, "done": (j.done == "0" ? false : true)])
            }
        }
        
        data = DBHelper.shared.readData(tableName: "history", column: column)
        if !data.isEmpty {
            for j in data {
                dataArray.append(["name": j.name!, "done": true, "date": j.date!])
            }
        }
        return dataArray
    }
}
