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
    init () {
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
    // 유저 정보 불러오기
    private func getUserInfo(completion: @escaping (String?) -> ()) {
        Auth.auth().addStateDidChangeListener { auth, user in
            completion(user?.uid)
        }
    }
    // 데이터 마이그레이션
    func dataMigration() {
        print("Firebase:: dataMigration:: Excuted")
        self.getUserInfo { [weak self] uid in
            guard let self = self,
                  let uid = uid
            else { return }
            for i in tableNames {
                let data = DBHelper.shared.readData(tableName: i, column: column)
                if data.isEmpty { continue }
                var dataArray = [[String: String]]()
                for j in data {
                    dataArray.append(["name": j.name!, "done": j.done!, "date": j.date!])
                }
                do {
                    try Firestore.firestore().collection("users").document(uid).updateData(["\(i)": dataArray])
                    print("Firebase:: dataMigration:: success written document")
                } catch {
                    print("Firebase:: dataMigration:: fail writing document")
                }
                
            }
            DBHelper.shared.resetAllTable()
        }
    }
    // Firebase로부터 데이터 불러오기
    func getDataFromFirebase(dataName: String, completion: @escaping ([StudyModel]?) -> ()) {
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
                if key == dataName { return true }
                return false
            }) else { return }
            
            do {
                let jsonFile = try JSONSerialization.data(withJSONObject: filtered)
                let data = try JSONDecoder().decode([String: [StudyModel]].self, from: jsonFile)
                let converted = Array(data.values).flatMap{$0}
                completion(converted)
                print("Firebase:: getDataFromFirebase:: receive Data Successful")
            } catch {
                print("Firebase:: getDataFromFirebase:: receive Data Fail")
            }
        }
    }
    // Firebase의 데이터 지우기(Field 값 지우기)
    func removeFirebaseData() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let db = Firestore.firestore()
        do {
            try db.collection("users").document(uid).updateData(["todo": FieldValue.delete()])
            try db.collection("users").document(uid).updateData(["history": FieldValue.delete()])
            try db.collection("users").document(uid).updateData(["study": FieldValue.delete()])
            print("DBHelper:: delete Success")
        } catch {
            print("DBHelper:: do delete fail")
        }
    }
}
