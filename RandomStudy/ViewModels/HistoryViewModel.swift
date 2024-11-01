//
//  HistoryViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/18.
//

import Foundation

protocol HistoryViewModelDelegate: AnyObject {
    func fetchedData()
}
final class HistoryViewModel {
    // Firebase로부터 받은 "기록" 데이터
    private(set) var historyData: [FirebaseDataModel] = [] {
        didSet {
            makeCompletions()
            getSectionCellCountArray()
        }
    }
    // Cell에 뿌려질 기록 데이터 배열
    var completions: [FirebaseDataModel] = [] {
        didSet {
            print("DIDSET completions(\(completions.count))")
            print(completions)
            delegate?.fetchedData()
        }
    }
    // Section별 Cell의 개수를 저장한 배열 index: section
    var sectionCellCount = [Int]()
    // 검색창에 검색어 쓰여져있는중인지 판단하는 변수
    var searchEditing: Bool = false
    // 검색창의 검색어
    // 검색어가 변경될때 마다 Cell내용 변경
    var searchText: String = "" {
        didSet {
            makeCompletions()
            getSectionCellCountArray()
        }
    }
    weak var delegate: HistoryViewModelDelegate?
    init () {
        print("HistoryVM:: init ")
        self.fetchData()
    }
    var count: Int {
        return completions.count
    // Firebase에서 데이터 가져오기
    private func fetchData() {
        historyData = FirebaseManager.shared.getFilteredData(type: .history)
    }
    var dateCount: Int {
        return Array(Set(completions.compactMap { $0.date })).count
    // Cell에 뿌려질 데이터배열 최신화 메서드
    private func makeCompletions(){
        var output: [FirebaseDataModel] = []
        if searchEditing {
            output = filteredCompletions(text: searchText)
        } else {
            output = historyData
        }
        completions = output
    }
    
    var dateArray: [String] {
        return Array(Set(completions.compactMap { $0.date })).sorted()
    // Cell에 뿌려지는 데이터배열을 검색어와 일치하는 배열로 변환하는 메서드
    private func filteredCompletions(text: String) -> [FirebaseDataModel] {
        var output: [FirebaseDataModel] = []
        for element in historyData {
            if isContains(searchText: text, data: element) {
                output.append(element)
            }
        }
        return output
    }
    private func fetchData() {
        completions = FirebaseManager.shared.getFilteredData(type: .history)
    // 기록 데이터중 완료날짜 개수
    func dateCount() -> Int {
        var output: [FirebaseDataModel] = []
        if searchEditing {
            output = self.filteredCompletions(text: self.searchText)
        } else {
            output = self.historyData
        }
        return Array(Set(output.compactMap{ $0.date})).count
    }
    // 데이터중 날짜만 중복없이 리턴
    func dateArray() -> [String] {
        var output: [FirebaseDataModel] = []
        if searchEditing {
            output = self.filteredCompletions(text: self.searchText)
        } else {
            output = self.historyData
        }
        return Array(Set(output.compactMap{ $0.date})).sorted()
    }
    }
}
