//
//  TodayViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/11.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol TodayViewModelDelegate: AnyObject {
    func didUpdateToday()
}

final class TodayViewModel {
    
    // MARK: Property
    weak var delegate: TodayViewModelDelegate?
    private let db = Firestore.firestore()
    
    var todo: [StudyModel] = [] {
        didSet {
            delegate?.didUpdateToday()
        }
    }
    
    init() {
        print("today viewmodel init")
        self.fetchData()
    }
    
    private var dateFommatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년MM월dd일"
        
        return dateFormatter
    }()
    
    var dataCount: Int {
        return todo.count
    }
    
    // MARK: Method
    // 추가한 공부목록으로 부터 불러오는 메소드 (불러오기)
    func uploadStudy() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Firebase.shared.getDataFromFirebase(dataName: "study") { [weak self] dataModel in
            guard let self = self,
                  let data = dataModel
            else { return }
            for i in data {
                let filtered = self.todo.filter{$0.name == i.name}
                if filtered.isEmpty {
                    
                    let data = [["name": i.name, "done": "0", "date": "0"]]
                    print("different, data: \(data)")
                    self.db.collection("users").document(uid).updateData(["todo": FieldValue.arrayUnion(data)])
                }
            }
            self.fetchData()
        }
    }
    
    // 완료 버튼 이벤트
    func complete(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let previous = [["name": name, "done": "0", "date": "0"]]
        let completion = [["name": name, "done": "1", "date": dateFommatter.string(from: Date())]]
        self.insertDataToHistory(completion: completion)
        do {
            try db.collection("users").document(uid).updateData(["todo": FieldValue.arrayRemove(previous)])
            try db.collection("users").document(uid).updateData(["todo": FieldValue.arrayUnion(completion)])
            print("TodayVM:: Complete Success")
        } catch {
            print("TodayVM:: Complete Fail")
        }
        self.fetchData()
        
    }
    // 체크 버튼 이벤트
    func insertDataToHistory(completion: [[String: String]]) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        do {
            try db.collection("users").document(uid).updateData(["history": FieldValue.arrayUnion(completion)])
            print("TodayVM:: insertDataToHistory Success")
        } catch {
            print("TodayVM:: insertDataToHistory Fail")
        }
    }
    
    // 삭제버튼 이벤트
    func remove(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = todo.filter{$0.name == name}[0]
        let removed = [["name": data.name, "done": data.done, "date": data.date]]
        do {
            try db.collection("users").document(uid).updateData(["todo": FieldValue.arrayRemove(removed)])
            print("TodayVM:: Remove Success")
        } catch {
            print("TodayVM:: Remove Fail")
        }
        self.fetchData()
    }
    // 데이터 최신화
    func fetchData() {
        Firebase.shared.getDataFromFirebase(dataName: "todo") { [weak self] dataModel in
            guard let self = self,
            let data = dataModel
            else { return }
            self.todo = data
        }
    }
    
}
