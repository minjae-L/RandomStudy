//
//  AddViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/25.
//

import Foundation

protocol AddViewModelDelegate: AnyObject {
    func didUpdate(with value: [Study])
}

final class AddViewModel {
    
    weak var delegate: AddViewModelDelegate?
    
    private(set) var elements: [Study] = StudyListUserDefaults.shared.data {
        didSet {
            delegate?.didUpdate(with: elements)
        }
    }
    
    var dataCount: Int {
        return elements.count
    }
    
    var study: [Study] {
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
        self.elements.append(Study(name: str))
    }
    
    func removeData(index: Int) {
        elements.remove(at: index)
    }
}




