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
    
    private(set) var completions: [FirebaseDataModel] = [] {
        didSet {
            delegate?.fetchedData()
        }
    }
    weak var delegate: HistoryViewModelDelegate?
    init () {
        print("HistoryVM:: init ")
        self.fetchData()
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
    private func fetchData() {
        FirebaseManager.shared.getDataFromFirebase(dataName: "data") { [weak self] dataModel in
            guard let self = self,
                  let data = dataModel
            else { return }
            self.completions = data.filter{$0.date != nil && $0.done != nil}
        }
    }
}
