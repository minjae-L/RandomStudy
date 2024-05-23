//
//  AddViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/25.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol AddViewModelDelegate: AnyObject {
    func didUpdate(with value: [StudyModel])
}

final class AddViewModel {
    
    weak var delegate: AddViewModelDelegate?
    private let db = Firestore.firestore()
    private var elements: [StudyModel] = [] {
        didSet {
            delegate?.didUpdate(with: elements)
        }
    }
    init() {
        self.fetchData()
    }
    var dataCount: Int {
        return elements.count
    }
    
    var study: [StudyModel] {
        return elements
    }
    func isContainsElement(str: String) -> Bool {
        var isContain = false
        for i in 0..<elements.count {
            if elements[i].name == str {
                isContain = true
                break
            }
        }
        return isContain
    }
    
    // 배열에 값 추가
    func addData(str: String) {
        if str == "" { return }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let data: [[String: String]] = [["name": str, "done": "0", "date": "0"]]
        do {
            try db.collection("users").document(uid).updateData(["study": FieldValue.arrayUnion(data)])
            print("addVM:: Success Data Write")
        } catch {
            print("addVM:: Fail Data Write")
        }
        self.fetchData()
    }
    
    func removeData(name: String) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let removed: [[String: String]] = [["name": name, "done": "0", "date": "0"]]
        do {
            try db.collection("users").document(uid).updateData(["study": FieldValue.arrayRemove(removed)])
            print("addVM:: Success Data Removed")
        } catch {
            print("addVM:: Fail Data Removed")
        }
        self.fetchData()
    }
    func fetchData() {
        Firebase.shared.getDataFromFirebase(dataName: "study") { [weak self] dataModel in
            guard let self = self, let data = dataModel else {
                self?.elements = []
                return
            }
            self.elements = data
        }
    }
}




