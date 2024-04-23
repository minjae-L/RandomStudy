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
    private let tableName = "study"
    private let column = ["name", "done", "date"]
    
    private var elements: [StudyModel] = DBHelper.shared.readData(tableName: "study", column: ["name", "done", "date"]) {
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
        var data = [str]
        for i in 0..<column.count-1 {
            data.append("0")
        }
        DBHelper.shared.insertData(tableName: tableName, columns: column, insertData: data)
        elements = DBHelper.shared.readData(tableName: tableName, column: column)
    }
    
    func removeData(name: String) {
        var index = -1
        for i in 0..<elements.count {
            if elements[i].name == name, let num = elements[i].id {
                index = num
            }
        }
        DBHelper.shared.deleteData(tableName: tableName, id: index)
        elements = DBHelper.shared.readData(tableName: tableName, column: column)
    }
    func fetchData() {
        self.elements = DBHelper.shared.readData(tableName: tableName, column: column)
    }
}




