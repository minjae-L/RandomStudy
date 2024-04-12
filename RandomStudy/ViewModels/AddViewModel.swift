//
//  AddViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/25.
//

import Foundation

protocol AddViewModelDelegate: AnyObject {
    func didUpdate(with value: [StudyModel])
}

final class AddViewModel {
    
    weak var delegate: AddViewModelDelegate?
    private let db = DBHelper()
    private let tableName = "study"
    private let column = ["name"]

    private var elements: [StudyModel] = DBHelper.shared.readData(tableName: "study", column: ["name"]) {
        didSet {
            delegate?.didUpdate(with: elements)
        }
    }
    
    var dataCount: Int {
        return elements.count
    }
    
    var study: [StudyModel] {
        return elements
    }
    func createDBTable() {
        db.createTable(tableName: tableName, stringColumn: column)
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
        db.insertData(tableName: tableName, columns: column, insertData: [str])
        elements = db.readData(tableName: tableName, column: column)
        print(elements)
    }
    
    func removeData(name: String) {
        var index = -1
        for i in 0..<elements.count {
            if elements[i].name == name, let num = elements[i].id {
                index = num
            }
        }
        db.deleteData(tableName: tableName, id: index)
        elements = db.readData(tableName: tableName, column: column)
        print(elements)
        
    }
}




