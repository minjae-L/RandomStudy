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

class ObservableViewModel {
    var list: Observable<[Study]> = Observable([])
     
    init() {
        self.list.value = Database.data
    }
    
    var count: Int {
        return list.value.count
    }
    
    var study: [Study] {
        let arr = list.value
        return arr
    }
}

// 데이터 가공 및 판별 메소드
extension ObservableViewModel {
    
    // 같은 데이터가 있는지 판단
    func isContainsElement(str: String) -> Bool {
        var isContain = false
        for i in 0..<study.count {
            if study[i].name == str {
                isContain = true
                break
            }
        }
        return isContain
    }
    
    // 배열에 값 추가
    func addData(str: String) {
        if str == "" { return }
        self.list.value.append(Study(name: str))
    }
    
    // 데이터 저장
    func setData() {
        Database.data = self.study
    }
    
    func removeData(index: Int) {
        var arr = list.value
        if arr.isEmpty { return }
        arr.remove(at: index)
        list.value = arr
    }

}




