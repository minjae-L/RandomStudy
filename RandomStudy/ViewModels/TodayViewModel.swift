//
//  TodayViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/11.
//

import Foundation
import UIKit

class ObservableTodayViewModel {
    var todayStudy: Observable<[TodayStudyList]> = Observable([])
    
    private var dateFommatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년MM월dd일"
        
        return dateFormatter
    }()
    
    init() {
        self.todayStudy.value = todayStudy.value
    }
    
    var count: Int {
        return todayStudy.value.count
    }

    var studyList: [TodayStudyList] {
        let arr = todayStudy.value
        return arr
    }
}

// 비즈니스 로직
extension ObservableTodayViewModel {
    // 추가한 공부목록으로 부터 불러오는 메소드
    func uploadData() {
        let study = Database.data
        if !study.isEmpty {
            for data in study {
                let element1 = TodayStudyList(name: data.name, isDone: false, date: dateFommatter.string(from: Date()))
                let element2 = TodayStudyList(name: data.name, isDone: true, date: dateFommatter.string(from: Date()))
                if !todayStudy.value.contains(element1) && !todayStudy.value.contains(element2) {
                    todayStudy.value.append(element1)
                }
            }
        }
    }
    // 완료 버튼 이벤트
    func complete(index: Int) {
        todayStudy.value[index].isDone = true
    }
    // 삭제버튼 이벤트
    func remove(index: Int) {
        todayStudy.value.remove(at: index)
    }
}
