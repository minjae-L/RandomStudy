//
//  HistoryViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/18.
//

import Foundation

class HistoryViewModel {
    
    weak var historyDelegate: HistoryViewModelDelegate?
    
    var completions: [CompletionList] = HistoryUserDefaults.shared.data {
        didSet {
            historyDelegate?.didUpdateHistory(with: completions)
        }
    }
    
    var count: Int {
        return completions.count
    }
    
    var dateCount: Int {
        return Array(Set(completions.compactMap { $0.date })).count
    }
    
    var dateArray: [String] {
        return Array(Set(completions.compactMap { $0.date })).sorted()
    }
    
    func isContainElement(_ element: CompletionList) -> Bool {
        for data in completions {
            if data == element {
                return true
            }
        }
        return false
    }
    
    func addData(_ element: CompletionList) {
        self.completions.append(element)
    }
    
}
