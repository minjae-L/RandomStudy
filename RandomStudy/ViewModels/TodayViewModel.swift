//
//  TodayViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/11.
//

import Foundation
import FirebaseAuth
import FirebaseFirestore

protocol TodayViewModelDelegate: AnyObject {
    func didUpdateToday(with value: [SM])
}

final class TodayViewModel {
    
    // MARK: Property
    weak var delegate: TodayViewModelDelegate?
    var tableName = "todo"
    var column = ["name", "done", "date"]
    var db = DBHelper()
    var td: [SM] = [] {
        didSet {
            print("td didSet")
            delegate?.didUpdateToday(with: td)
        }
    }
    var todo: [StudyModel] = DBHelper.shared.readData(tableName: "todo", column:  ["name", "done", "date"]) {
        didSet {
//            delegate?.didUpdateToday(with: todo)
        }
    }
    let database = Firestore.firestore()
    
    init() {
        db.delegate = self
        print("today viewmodel init")

        DBHelper.shared.getDataFromFirebase(dataName: "todo") { dataModel in
            print("vm in td: \(dataModel)")
            guard let data = dataModel else {
                self.td = []
                return
            }
            self.td = data
        }
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
    func getDataFromFirebase() {
        DBHelper.shared.getDataFromFirebase(dataName: "todo") { dataModel in
            guard let data = dataModel else { return }
            self.td = data
            print("td recieved")
            print(self.td)
        }
    }
    // 추가한 공부목록으로 부터 불러오는 메소드 (불러오기)
    func fetchData() {
        let study = DBHelper.shared.readData(tableName: "study", column: column)
        for i in study {
            var check = true
            for j in todo {
                if i.name == j.name {
                    check = false
                    break
                }
            }
            if check {
                guard let name = i.name, let done = i.done, let date = i.date else { return }
                let data = [name, done, date]
                DBHelper.shared.insertData(tableName: tableName, columns: column, insertData: data)
                todo.append(i)
                
            }
        }
    }
    
    // 완료 버튼 이벤트
    func complete(name: String) {
        guard let id = todo.filter{$0.name == name}[0].id else { return }
        DBHelper.shared.updateData(tableName: tableName, id: id, done: "1", date: dateFommatter.string(from: Date()))
        todo = DBHelper.shared.readData(tableName: tableName, column: column)
        insertDataToHistory(id: id)
        
    }
    // 체크 버튼 이벤트
    func insertDataToHistory(id: Int) {
        for i in 0..<todo.count {
            if todo[i].id == id {
                guard let name = todo[i].name, let done = todo[i].done, let date = todo[i].date else { return }
                let data = [name, done, date]
                DBHelper.shared.insertData(tableName: "history", columns: column, insertData: data)
                break
            }
        }
    }
    
    // 삭제버튼 이벤트
    func remove(name: String) {
        var id = -1
        for i in 0..<todo.count {
            if todo[i].name == name, let index = todo[i].id {
                id = index
                todo.remove(at: i)
                break
            }
        }
        DBHelper.shared.deleteData(tableName: tableName, id: id)
    }
    // 데이터 최신화
    func fetchTodoList() {
        self.todo = DBHelper.shared.readData(tableName: tableName, column: column)
    }
    
}

extension TodayViewModel: DBHelperDelegate {
    func removeAllDatas() {
        print("DBDelegate - todo")
        todo.removeAll()
    }
}
