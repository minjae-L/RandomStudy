//
//  DBHelper.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/04/11.
//

import Foundation
import SQLite3

class DBHelper {
    var db: OpaquePointer?
    var databaseName: String = "mydb.sqlite"
    static let shared = DBHelper()
    init() {
        self.db = createDB()
    }
    
    deinit {
        sqlite3_close(db)
    }
    
    func createDB() -> OpaquePointer? {
        let filePath = try! FileManager.default.url(for: .documentDirectory,
                                                    in: .userDomainMask,
                                                    appropriateFor: nil,
                                                    create: false).appendingPathExtension(databaseName).path
        
        var db: OpaquePointer? = nil
        
        if sqlite3_open(filePath, &db) != SQLITE_OK {
            print("There is error in creating DB")
            return nil
        } else {
            print("Database is been created with path \(databaseName)")
            return db
        }
    }
    
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
            var d = StudyModel(id: Int(id), name: nil, done: nil, date: nil)
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
    
}
