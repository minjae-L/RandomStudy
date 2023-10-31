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
        completionStudy.value = HistoryUserDefaults.shared.data
//        if let data = UserDefaults.standard.value(forKey: "completionStudy") as? Data {
//            self.completionStudy.value = try! PropertyListDecoder().decode(Array<CompletionList>.self, from: data)
//        }
    }
    
    var count: Int {
        return completionStudy.value.count
    }
    
    var completionList: [CompletionList] {
        return completionStudy.value
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
    // Userdefaults 데이터 저장
//    func userdefaultsDataSet() {
//        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(completionStudy.value), forKey: "completionStudy")
//    }
    // 중복된 원소가 있는지 판단하는 메소드
    func isContainElement(_ element: CompletionList) -> Bool {
        let arr = completionList
        for data in arr {
            if data == element {
                return true
            }
        }
        return false
        
    }
    // 원소 추가
    func addData(_ element: CompletionList) {
//        if name == "" || date == "" { return }
//        guard let data = element else { return }
        self.completionStudy.value.append(element)
    }
}
