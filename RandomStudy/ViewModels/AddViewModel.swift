//
//  AddViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/25.
//

import Foundation

// Observable 선언
class Observable<T> {
    // 3. 호출되면, 2번에서 받은 값을 전달.
    private var listener: ((T) -> Void)?
    
    // 2. value에 값이 설정되면, listener에 해당값을 전달
    var value: T {
        didSet {
            listener?(value)
        }
    }
    // 1. 초기화함수로 값을 입력받고, value 에 저장.
    init(_ value: T) {
        self.value = value
    }
    
    // 4. 다른곳에서 bind라는 메소드를 호출하면, value에 저장된 값을 전달,
    // 전달받은 closure 표현식을 listener에 할당
    func bind(_ closure: @escaping (T) -> Void) {
        closure(value)
        listener = closure
    }
}

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




