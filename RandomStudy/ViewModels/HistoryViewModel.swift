//
//  HistoryViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/18.
//

import Foundation
import UIKit

class ObservableHistoryViewModel {
    var completionStudy: Observable<[CompletionList]> = Observable([])
    
    // 생성시 데이터베이스에서 불러오기
    init() {
        self.completionStudy.value = FinishedList.data
    }
    
    var count: Int {
        return completionStudy.value.count
    }
    
    var completionList: [CompletionList] {
        let arr = completionStudy.value
        return arr
    }
    
    // 중복되지않은 날짜의 개수
    var dateCount: Int {
        return Array(Set(completionStudy.value.map{ $0.date! })).count
    }
    // 날짜 배열 리턴
    var dateArray: [String] {
        return Array(Set(completionStudy.value.map{ $0.date! })).sorted()
    }
    
}

extension ObservableHistoryViewModel {
    // 중복된 원소가 있는지 판단하는 메소드
    func isContainElement(name: String, date: String) -> Bool {
        let arr = completionStudy.value
        if arr.contains(CompletionList(name: name, date: date)) {
            return true
        } else {
            return false
        }
    }
    // 원소 추가
    func addData(name: String, date: String) {
        if name == "" || date == "" { return }
        self.completionStudy.value.append(CompletionList(name: name, date: date))
        self.setData()
    }
    // 데이터베이스에 저장
    func setData() {
        FinishedList.data = completionStudy.value
    }
}
