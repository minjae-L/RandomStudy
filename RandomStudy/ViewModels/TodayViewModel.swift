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
        if let data = UserDefaults.standard.value(forKey: "todayStudy") as? Data {
            self.todayStudy.value = try! PropertyListDecoder().decode(Array<TodayStudyList>.self, from: data)
        }
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
    // 추가해뒀던 공부목록 불러오기
    func loadStudyList() -> [Study] {
        var arr = [Study]()
        if let data = UserDefaults.standard.value(forKey: "studyList") as? Data {
            arr = try! PropertyListDecoder().decode(Array<Study>.self, from: data)
        }
        return arr
    }
    // 완료된 목록 불러오기
    func loadCompletionList() -> [CompletionList] {
        var arr = [CompletionList]()
        if let data = UserDefaults.standard.value(forKey: "completionStudy") as? Data {
            arr = try! PropertyListDecoder().decode(Array<CompletionList>.self, from: data)
        }
        return arr
    }
    // UserDefaults 데이터 저장
    func userdefaultsDataSet() {
        UserDefaults.standard.setValue(try? PropertyListEncoder().encode(todayStudy.value), forKey: "todayStudy")
        
    }
    
    // 현재 상태를 확인하는 메소드 0: 공부목록이 없음, 1: 모든 데이터를 불러옴, 2: 불러올 데이터가 남아있음
    func checkUploadData() -> Int {
        if self.loadStudyList().isEmpty {
            return 0
        } else if self.isAllDataUploaded() {
            return 1
        } else {
            return 2
        }
    }
    //  모든 데이터가 불러와졌는지 확인하는 메소드
    func isAllDataUploaded() -> Bool {
        let uploaded = studyList
        for data in self.loadStudyList() {
            let element1 = TodayStudyList(name: data.name, isDone: false, date: dateFommatter.string(from: Date()))
            let element2 = TodayStudyList(name: data.name, isDone: true, date: dateFommatter.string(from: Date()))
            if !todayStudy.value.contains(element1) && !todayStudy.value.contains(element2) {
                return false
            }
        }
        return true
    }
    
    // 추가한 공부목록으로 부터 불러오는 메소드
    func uploadData() {
        let studyList = self.loadStudyList()
        let completionList = self.loadCompletionList()
        let currentDate = dateFommatter.string(from: Date())
        // 목록이 중복되거나 이미 완료된 목록인지 확인
        for data in self.loadStudyList() {
            let element1 = TodayStudyList(name: data.name, isDone: false, date: currentDate)
            let element2 = TodayStudyList(name: data.name, isDone: true, date:  currentDate)
            if !todayStudy.value.contains(element1) && !todayStudy.value.contains(element2) {
                if !completionList.contains(CompletionList(name: data.name, date: currentDate)) {
                    todayStudy.value.append(element1)
                } else {
                    todayStudy.value.append(element2)
                }
                    
            }
        }
    }
    // 완료 버튼 이벤트
    func complete(index: Int) {
        if !todayStudy.value[index].isDone {
            todayStudy.value[index].isDone = true
        }
    }
    // 삭제버튼 이벤트
    func remove(index: Int) {
        todayStudy.value.remove(at: index)
    }
    // 목록 초기화
    func removeAll() {
        todayStudy.value.removeAll()
    }
}
