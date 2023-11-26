//
//  TodayViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/11.
//

import Foundation

protocol HistoryViewModelDelegate: AnyObject {
    func didUpdateHistory(with value: [CompletionList])
}
protocol TodayViewModelDelegate: HistoryViewModelDelegate {
    func didUpdateToday(with value: [TodayStudyList])
}

class TodayViewModel: HistoryViewModel {
    
    // MARK: Property
    weak var todayDelegate: TodayViewModelDelegate?
    
    var todayStudy: [TodayStudyList] = TodayStudyUserDefauls.shared.data {
        didSet {
            todayDelegate?.didUpdateToday(with: todayStudy)
        }
    }
    
    private var dateFommatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년MM월dd일"
        
        return dateFormatter
    }()
    
    var dataCount: Int {
        return todayStudy.count
    }

    var todayList: [TodayStudyList] {
        return todayStudy
    }
    
    // MARK: Method
    
    // 추가해뒀던 공부목록 불러오기
    private func loadStudyList() -> [Study] {
        return StudyListUserDefaults.shared.data
    }
    
    // 완료된 목록 불러오기
    private func loadCompletionList() -> [CompletionList] {
        var arr = [CompletionList]()
        if let data = UserDefaults.standard.value(forKey: "completionStudy") as? Data {
            arr = try! PropertyListDecoder().decode(Array<CompletionList>.self, from: data)
        }
        return arr
    }
    
    // 현재 상태를 확인하는 메소드
    func checkDataState() -> DateState {
        if self.loadStudyList().isEmpty {
            return DateState.empty
        } else if self.isAllDataUploaded() {
            return DateState.finish
        } else {
            return DateState.loading
        }
    }
    
    //  모든 데이터가 불러와졌는지 확인하는 메소드
    private func isAllDataUploaded() -> Bool {
        let uploaded = todayList
        for data in self.loadStudyList() {
            let element1 = TodayStudyList(name: data.name, isDone: false, date: dateFommatter.string(from: Date()))
            let element2 = TodayStudyList(name: data.name, isDone: true, date: dateFommatter.string(from: Date()))
            if !uploaded.contains(element1) && !uploaded.contains(element2) {
                return false
            }
        }
        return true
    }
    
    // 추가한 공부목록으로 부터 불러오는 메소드
    func fetchData() {
        let studyList = self.loadStudyList()
        let completionList = self.loadCompletionList()
        let currentDate = dateFommatter.string(from: Date())
        var arr = [TodayStudyList]()
        // 목록이 중복되거나 이미 완료된 목록인지 확인
        for data in studyList {
            let element = TodayStudyList(name: data.name, isDone: false, date: currentDate)
            let completeElement = CompletionList(name: data.name, date: currentDate)
            if completionList.contains(completeElement) || todayList.contains(element) { continue }
            arr.append(element)
        }
        todayStudy.append(contentsOf: arr)
    }
    // 완료 버튼 이벤트
    func complete(index: Int) {
        if !todayStudy[index].isDone {
            todayStudy[index].isDone = true
        }
    }
    
    // 삭제버튼 이벤트
    func remove(item: TodayStudyList?) {
        guard let item = item,
              let index = todayStudy.firstIndex(where: { $0 == item }) else { return }
        todayStudy.remove(at: index)
    }
    
    // 목록 초기화
    func removeAll() {
        todayStudy.removeAll()
    }
}
