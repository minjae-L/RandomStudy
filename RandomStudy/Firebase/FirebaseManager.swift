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
            do {
                try Firestore.firestore().collection("users").document(uid).updateData(["data": FieldValue.arrayUnion(getDataFromSQLite())])
                print("Firebase:: dataMigration:: success written document")
            } catch {
                print("Firebase:: dataMigration:: fail writing document")
            }
            DBHelper.shared.resetAllTable()
        }
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
    // Firebase로부터 데이터 불러오기
    func getDataFromFirebase(dataName: String, completion: @escaping ([FirebaseDataModel]?) -> ()) {
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
                let data = try JSONDecoder().decode([String: [FirebaseDataModel]].self, from: jsonFile)
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
            try db.collection("users").document(uid).updateData(["data": FieldValue.delete()])
            print("DBHelper:: delete Success")
        } catch {
            print("DBHelper:: do delete fail")
        }
    }
}
