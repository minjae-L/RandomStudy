//
//  FirebaseDatabase.swift
//  RandomStudy
//
//  Created by 이민재 on 5/23/24.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

class Firebase {
    private let db = Firestore.firestore()
    static let shared = Firebase()
    private let tableNames = ["study", "todo", "history"]
    private let column = ["name", "done", "date"]
    init () {
    }
    
    func isDataExist() -> Bool{
        for i in tableNames {
            let data = DBHelper.shared.readData(tableName: i, column:  column)
            if !data.isEmpty { return true }
        }
        return false
    }
    func getUserInfo(completion: @escaping (String?) -> ()) {
        Auth.auth().addStateDidChangeListener { auth, user in
            completion(user?.uid)
        }
    }
    func dataMigration() {
        self.getUserInfo { [weak self] uid in
            guard let self = self,
                  let uid = uid
            else { return }
            do {
                try Firestore.firestore().collection("users").document(uid).setData(["uid": uid])
                print("Firebase:: dataMigration:: success written uid")
            } catch {
                print("Firebase:: dataMigration:: fail writing uid")
            }
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
    func getDataFromFirebase(dataName: String, completion: @escaping ([StudyModel]?) -> ()) {
        guard let uid = Auth.auth().currentUser?.uid else {
            completion(nil)
            return
        }
        let db = Firestore.firestore()
        db.collection("users").whereField("uid", isEqualTo: uid).getDocuments { snapshot, error in
            if error != nil {
                let networkError = error as! NSError
                print(networkError.localizedDescription)
                completion(nil)
                return
            }
            if snapshot!.documents.isEmpty {
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
                print("receive Data Successful")
            } catch {
                print("receive Data Fail")
            }
        }
    }
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
