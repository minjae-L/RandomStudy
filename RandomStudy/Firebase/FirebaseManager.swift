//
//  FirebaseDatabase.swift
//  RandomStudy
//
//  Created by 이민재 on 5/23/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol FirebaseManagerDelegate: AnyObject {
    func didFinishedDataUploading()
}
class FirebaseManager {
    private let db = Firestore.firestore()
    static let shared = FirebaseManager()
    private let tableNames = ["study", "todo", "history"]
    private let column = ["name", "done", "date"]
    private var uid: String
    weak var delegate: FirebaseManagerDelegate?
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
            self?.delegate?.didFinishedDataUploading()
        }
    }
    // Firebase로부터 데이터 불러오기
    func getDataFromFirebase(completion: @escaping ([FirebaseDataModel]?) -> ()) {
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
