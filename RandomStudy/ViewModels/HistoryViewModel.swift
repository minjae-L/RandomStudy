//
//  HistoryViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/18.
//

import Foundation

final class HistoryViewModel {
    
    var completions: [StudyModel] = DBHelper.shared.readData(tableName: "history", column: ["name", "done", "date"])
    private let tableName = "history"
    private let column = ["name", "done", "date"]
    
    var count: Int {
        return completions.count
    }
    var dateCount: Int {
        return Array(Set(completions.compactMap { $0.date })).count
    }
    
    var dateArray: [String] {
        return Array(Set(completions.compactMap { $0.date })).sorted()
    }
}
