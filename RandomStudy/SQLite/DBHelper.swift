//
//  DBHelper.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/04/11.
//

import Foundation
import SQLite3

struct dbGrade: Codable {
    var id: Int
    var name: String
    var done: Int
    var date: String
    
}

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
    
    func createTable() {
        let query = "CREATE TABLE IF NOT EXISTS study(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT, done BOOL, date TEXT);"
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
    
    func deleteTable() {
        let query = "DROP TABLE study"
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
    
    func insertData(name: String, isDone: Int, date: String) {
        let insertQuery = "insert into study (id, name, done, date) values (?, ?, ?, ?);"
        var statement: OpaquePointer? = nil

        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            sqlite3_bind_text(statement, 2, NSString(string: name).utf8String, -1, nil)
            sqlite3_bind_int(statement, 3, Int32(isDone))
            sqlite3_bind_text(statement, 4, NSString(string: date).utf8String, -1, nil)
        } else {
            print("bind fail")
        }
        
        if sqlite3_step(statement) == SQLITE_DONE {
            print("insert success")
        } else {
            print("step fail")
        }
    }
    
    func readData() -> [dbGrade] {
        let query: String = "select * from study;"
        var statement: OpaquePointer? = nil
        
        var result: [dbGrade] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(error)")
            return result
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            
            let id = sqlite3_column_int(statement, 0)
            let name = String(cString: sqlite3_column_text(statement, 1))
            let done = sqlite3_column_int(statement, 2)
            let date = String(cString: sqlite3_column_text(statement, 3))
            print("id: \(id), name: \(name), done: \(done), date: \(date)")

            result.append(dbGrade(id: Int(id), name: String(name), done: Int(done), date: String(date)))
        }
        sqlite3_finalize(statement)
        print("result = \(result)")
        return result
    }
    
}
