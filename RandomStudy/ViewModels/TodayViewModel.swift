//
//  TodayViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/11.
//

import Foundation

protocol TodayViewModelDelegate: AnyObject {
    func didUpdateToday()
}

final class TodayViewModel {
     
    // MARK: Property
    weak var delegate: TodayViewModelDelegate?
    private(set) var todo: [FirebaseDataModel] = [] {
        didSet {
            print("todo didset")
            delegate?.didUpdateToday()
        }
    }
    
    init() {
        print("today viewmodel init")
        self.fetchData()
        FirebaseManager.shared.delegate = self
    }
    
    private var dateFommatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년MM월dd일"
        
        return dateFormatter
    }()
    
    var dataCount: Int {
        return todo.count
    }
    
    // MARK: Method
    // 추가한 공부목록으로 부터 불러오는 메소드 (불러오기)
    func uploadStudy() {
        let arr = FirebaseManager.shared.getFilteredData(type: .todo).map{$0.name}
        let strArray = self.todo.map{$0.name}
        for element in arr {
            if !strArray.contains(element) {
                let data = FirebaseDataModel(name: element, done: false)
                FirebaseManager.shared.setDataToFirebase(data: data)
            }
        }
        self.fetchData()
    }
    
    // 완료 버튼 이벤트
    func complete(name: String) {
        let previous = FirebaseDataModel(name: name, done: false, date: nil)
        let next = FirebaseDataModel(name: name, done: true, date: nil)
        let completion = FirebaseDataModel(name: name, done: true, date: dateFommatter.string(from: Date()))
        FirebaseManager.shared.removeDataFromFirebase(data: previous)
        FirebaseManager.shared.setDataToFirebase(data: next)
        FirebaseManager.shared.setDataToFirebase(data: completion)
    }
    
    // 삭제버튼 이벤트
    func remove(name: String) {
        guard let data = todo.filter{$0.name == name && $0.date == nil }.first else { return }
        print("data: \(data)")
        FirebaseManager.shared.removeDataFromFirebase(data: data)
        self.fetchData()
    }
    // 데이터 최신화
    func fetchData() {
        self.todo = FirebaseManager.shared.getFilteredData(type: .today)
    }
}

extension TodayViewModel: FirebaseManagerDelegate {
    func didFinishedDataUploading() {
        print("firebaseManagerDelegate")
        self.fetchData()
        delegate?.didUpdateToday()
    }
}
