//
//  AddViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/25.
//

import Foundation

protocol AddViewModelDelegate: AnyObject {
    func didUpdate(with value: [FirebaseDataModel])
}

final class AddViewModel {
    
    weak var delegate: AddViewModelDelegate?
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
    func insert(name: String) {
        if name == "" { return }
        let data = FirebaseDataModel(name: name)
        FirebaseManager.shared.setDataToFirebase(data: data)
        self.fetchData()
    }
    func remove(name: String) {
        let data = FirebaseDataModel(name: name)
        FirebaseManager.shared.removeDataFromFirebase(data: data)
        self.fetchData()
    }
    func fetchData() {
        self.elements = FirebaseManager.shared.getFilteredData(type: .todo)
    }
}

