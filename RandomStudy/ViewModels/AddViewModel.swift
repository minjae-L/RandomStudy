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
    func didUpdate(with value: [FirebaseDataModel])
}

final class AddViewModel {
    
    weak var delegate: AddViewModelDelegate?
    private let db = Firestore.firestore()
    private var elements: [FirebaseDataModel] = [] {
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
    
    var study: [FirebaseDataModel] {
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
    func insert(str: String) {
        if str == "" { return }
        let data = FirebaseDataModel(name: str)
        FirebaseManager.shared.setDataToFirebase(data: data)
        self.fetchData()
    }
    func remove(name: String) {
        let data = FirebaseDataModel(name: name)
        FirebaseManager.shared.removeDataFromFirebase(data: data)
        self.fetchData()
    }
    func fetchData() {
        let arr = FirebaseManager.shared.elements.filter{ $0.date == nil && $0.done == nil}
        self.elements = arr
    }
}

