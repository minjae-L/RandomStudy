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
    
    func readData(tableName: String, column: [String]) -> [Dictionary<String, String>] {
        let query: String = "select * from \(tableName);"
        var statement: OpaquePointer? = nil
        
        var result: [Dictionary<String, String>] = []
        
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(error)")
        }
        while sqlite3_step(statement) == SQLITE_ROW {
            let id = sqlite3_column_int(statement, 0)
            var data = Dictionary<String, String>()
            for  i in 0..<column.count {
                data[column[i]] = String(cString: sqlite3_column_text(statement, Int32(i+1)))
            }
            result.append(data)
        }
        sqlite3_finalize(statement)
        return result
    }
    
}
