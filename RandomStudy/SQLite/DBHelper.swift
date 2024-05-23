//
//  DBHelper.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/04/11.
//

import Foundation
import SQLite3
import FirebaseAuth
import FirebaseFirestore

protocol DBHelperDelegate: AnyObject {
    func removeAllDatas()
}
class DBHelper {
    var db: OpaquePointer?
    var databaseName: String = "mydb.sqlite"
    static let shared = DBHelper()
    let tableNames = ["study", "todo", "history"]
    let column = ["name", "done", "date"]
    weak var delegate: DBHelperDelegate?
    init() {
        print("DB helper init")
        self.db = createDB()
        
        for i in tableNames {
            self.createTable(tableName: i, stringColumn: column)
            print("create table \(i)")
            print("table \(i): \(self.readData(tableName: i, column: column))")
        }
    }
    
    deinit {
        sqlite3_close(db)
    }

    //    MARK: Create DB
    
    func createDB() -> OpaquePointer? {
        let path = try! FileManager.default.url(for: .applicationSupportDirectory,
                                                in: .userDomainMask,
                                                appropriateFor: nil,
                                                create: true).appendingPathComponent(databaseName).path
        let filePath = try! FileManager.default.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false).appendingPathExtension(databaseName).path
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(path, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        } else {
            print("Database is been created with path \(databaseName)")
            return db
        }
    }
    
    //    MARK: Create Table
    func createTable(tableName: String, stringColumn: [String]) {
        var column: String = {
            var str = "id INTEGER PRIMARY KEY AUTOINCREMENT"
            for col in stringColumn {
                str += ", \(col) TEXT"
            }
            return str
        }()
        let query = "CREATE TABLE IF NOT EXISTS" + " \(tableName)" + "(\(column));"
        var createTable: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &createTable, nil) == SQLITE_OK {
            if sqlite3_step(createTable) == SQLITE_DONE {
                print("Table creation success \(String(describing: self.db))")
            } else {
                print("Table creation fail")
            }
        } else {
            print("Prepation fail")
        }
        sqlite3_finalize(createTable)
    }
    
    //    MARK: Delete Table
    func deleteTable(tableName: String) {
        let query = "DROP TABLE \(tableName)"
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete table success")
            } else {
                print("delete table fail")
            }
        } else {
            print("delete table prepare fail")
        }
    }
    
    //    MARK: Insert Data
    func insertData(tableName: String, columns: [String], insertData: [String]) {
        let column: String = {
            var column = "id"
            for col in columns {
                column += ", \(col)"
            }
            return column
        }()
        
        var value: String = {
            var value = "?"
            for val in 0..<insertData.count {
                value += ", ?"
            }
            return value
        }()
        
        let insertQuery = "insert into \(tableName) (\(column)) values (\(value));"
        print("insert query: \(insertQuery)")
        print("insert Data: \(insertData)")
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            for i in 0..<insertData.count {
                sqlite3_bind_text(statement, Int32(i)+2, NSString(string: insertData[i]).utf8String, -1, nil)
            }
            if sqlite3_step(statement) == SQLITE_DONE {
                print("insert success")
            } else {
                print("step fail")
            }
        } else {
            print("bind fail")
        }
        
    }
    
    //    MARK: Read data
    func readData(tableName: String, column: [String]) -> [StudyModel] {
        let query: String = "select * from \(tableName);"
        var statement: OpaquePointer? = nil
        
        var result: [StudyModel] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(error)")
            return []
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 0)
            var data = Dictionary<String, String>()
            var d = StudyModel(name: nil, done: nil, date: nil)
            for  i in 0..<column.count {
                data[column[i]] = String(cString: sqlite3_column_text(statement, Int32(i+1)))
                let load = String(cString: sqlite3_column_text(statement, Int32(i+1)))
                switch column[i] {
                case "name": d.name = load
                case "done": d.done = load
                case "date": d.date = load
                default: continue
                }
            }
            result.append(d)
        }
        sqlite3_finalize(statement)
        return result
    }
    
    //    MARK: Delete data
    func deleteData(tableName: String, id: Int) {
        let query = "delete from \(tableName) where id == \(id)"
        print(query)
        var statement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) == SQLITE_OK {
            if sqlite3_step(statement) == SQLITE_DONE {
                print("delete success")
            } else {
                print("delete fail")
            }
        } else {
            print("delete prepare fail")
        }
        sqlite3_finalize(statement)
    }
    
    //    MARK: Update data
    private func onSQLErrorPrintErrorMessage(_ db: OpaquePointer?) {
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("Error preparing Update \(errorMessage)")
        return
    }
    
    func updateData(tableName: String, id: Int, done: String, date: String) {
        var statement: OpaquePointer? = nil
        let query = "UPDATE \(tableName) SET done='\(done)',date='\(date)' WHERE id==\(id)"
        
        if sqlite3_prepare(db, query, -1, &statement, nil) != SQLITE_OK {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        
        if sqlite3_step(statement) != SQLITE_DONE {
            onSQLErrorPrintErrorMessage(db)
            return
        }
        
        print("Update has been successfully done")
    }
    
//    MARK: Reset All Tables
    func resetAllTable() {
        for i in tableNames {
            self.deleteTable(tableName: i)
            self.createTable(tableName: i, stringColumn: column)
            print("\(i) reset, \(i): \(readData(tableName: i, column: column))")
        }
        self.delegate?.removeAllDatas()
    }
    
    func makeSampleData() {
        for i in tableNames {
            self.insertData(tableName: i, columns: column, insertData: ["\(i)_1","0","0"])
            print("DBHelper:: makeSampleData:: \(self.readData(tableName: i, column: column))")
        }
        
    }
}

