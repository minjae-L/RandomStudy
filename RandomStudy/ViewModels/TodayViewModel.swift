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
    
    private(set) var todo: [FirebaseDataModel] = [] {
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
        FirebaseManager.shared.getDataFromFirebase(dataName: "data") { [weak self] dataModel in
            guard let self = self,
                  let data = dataModel
            else { return }
            let filtered = data.filter{$0.date == nil && $0.done == nil}
            for i in filtered {
                let contains = self.todo.filter{$0.name == i.name}
                if contains.isEmpty {
                    let data = [["name": i.name, "done": false]]
                    self.db.collection("users").document(uid).updateData(["data": FieldValue.arrayUnion(data)])
                }
            }
            self.fetchData()
        }
    }
    
    // 완료 버튼 이벤트
    func complete(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let previous = [["name": name, "done": false]]
        let cp = [["name": name, "done": true]]
        let completion = FirebaseDataModel(name: name, done: true, date: dateFommatter.string(from: Date()))
        self.insertDataToHistory(completion: completion)
        do {
            try db.collection("users").document(uid).updateData(["data": FieldValue.arrayRemove(previous)])
            try db.collection("users").document(uid).updateData(["data": FieldValue.arrayUnion(cp)])
            print("TodayVM:: Complete Success")
        } catch {
            print("TodayVM:: Complete Fail")
        }
        self.fetchData()
        
    }
    // 체크 버튼 이벤트
    func insertDataToHistory(completion: FirebaseDataModel) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = [["name": completion.name, "done": true, "date": dateFommatter.string(from: Date())]]
        do {
            try db.collection("users").document(uid).updateData(["data": FieldValue.arrayUnion(data)])
            print("TodayVM:: insertDataToHistory Success")
        } catch {
            print("TodayVM:: insertDataToHistory Fail")
        }
    }
    
    // 삭제버튼 이벤트
    func remove(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data = todo.filter{$0.name == name}[0]
        let removed = [["name": data.name, "done": data.done]]
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
        FirebaseManager.shared.getDataFromFirebase(dataName: "data") { [weak self] dataModel in
            guard let self = self,
            let data = dataModel
            else { return }
            self.todo = data.filter{$0.date == nil && $0.done != nil}
        }
    }
    
}
