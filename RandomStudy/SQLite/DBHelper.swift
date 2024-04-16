//
//  DBHelper.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/04/11.
//

import Foundation
import SQLite3

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
//        self.dele
    }
}

class DB {
    // 싱글톤
    static let shared = DB()
    
    // db를 가리키는 포인터
    var db: OpaquePointer? = nil
    // 데이터베이스 이름 형식: name.sqlite 로 만들것
    let databaseName = "database.sqlite"
    
    init() {
        
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
        """
        CREATE TABLE IF NOT EXISTS tablename(id INTEGER PRIMARY KEY AUTOINCREMENT, name: TEXT, done: TEXT NOT NULL, date: TEXT);
        이는 tablename이란 테이블이 존재하지 않으면 생성한다는 뜻입니다.
        id는 고유키가 되고, 데이터가 추가될때마다 자동으로 증가하는값을 가집니다.
        여기서 TEXT는 문자열을 받는것이고, NOT NULL은 NULL은 저장하지않는단얘기입니다. Swift에선 옵셔널이 아닌형식이 되겠네요
        저는 유연하게 테이블을 만들고자 테이블 이름과 저장할 데이터이름(column에 위치한)을 입력받습니다.
        물론 데이터의 형식도 위와같이 입력받아 더 유연하게 만들 수 있지만 복잡해지므로 문자열만 받겠습니다.
        """
        // 입력받은 데이터이름을 형식에 맞춰서 구성
        var column: String = {
            var str = "id INTEGER PRIMARY KEY AUTOINCREMENT"
            for col in stringColumn {
                str += ", \(col) TEXT"
            }
            return str
        }()
        // 쿼리 작성
        let query = "CREATE TABLE IF NOT EXISTS" + " \(tableName)" + "(\(column));"
        var createTable: OpaquePointer? = nil
        
        // 작성한 쿼리를 실행
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
    
    func insertData(tableName: String, columns: [String], insertData: [String]) {
        """
        데이터도 역시 유연하게 받기 위해 테이블이름, 데이터이름, 넣을 데이터를 입력 받습니다.
        이것도 역시 쿼리를 구성하고 실행하면 됩니다. 쿼리는 아래와 같이 구성합니다.
        insert into tablename (id, name, done, date) values (?, ?, ?, ?);
        tablename이란 테이블에 데이터를 집어넣는다. values 뒤에 ?는 넣을 데이터수에 맞춰 구성합니다. id포함
        """
        // 입력받은 데이터이름을 형식에 맞춰 구성
        let column: String = {
            var column = "id"
            for col in columns {
                column += ", \(col)"
            }
            return column
        }()
        // 입력받은 데이터에따라 인자 구성
        var value: String = {
            var value = "?"
            for val in 0..<insertData.count {
                value += ", ?"
            }
            return value
        }()
        
        // 쿼리작성
        let insertQuery = "insert into \(tableName) (\(column)) values (\(value));"
        var statement: OpaquePointer? = nil
        // 작성한 쿼리로 실행
        if sqlite3_prepare_v2(self.db, insertQuery, -1, &statement, nil) == SQLITE_OK {
            // 데이터 삽입
            for i in 0..<insertData.count {
                // 여기서 두번째 인자가 위 values에서 몇번째 ?에넣는가를 의미합니다.
                // 세번째 인자는 넣을 데이터를 형식에 맞춰 변환하여 넣습니다.
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
        """
        데이터를 읽는것도 역시나 쿼리작성후 해당 쿼리를 실행하는것 입니다.
        데이터도 역시 유연하게 읽기위해 tablename과 받을 데이터이름이 담긴 배열을 입력받습니다.
        쿼리구성: select * from tablename;
        """
        let query: String = "select * from \(tableName);"
        var statement: OpaquePointer? = nil
        
        // 앞서 선언했던 데이터받을 구조체의 배열
        var result: [StudyModel] = []
        // 구성한 쿼리로 실행
        if sqlite3_prepare_v2(self.db, query, -1, &statement, nil) != SQLITE_OK {
            let error = String(cString: sqlite3_errmsg(db)!)
            print("error while prepare: \(error)")
            return []
        }
        // Column에 값이 존재하지않을때 까지 모두 읽어옵니다.
        // 저는 입력받은 데이터를 순회하면서 리턴형식에 맞게 만들고 추가하는 방법을 사용했습니다.
        while sqlite3_step(statement) == SQLITE_ROW {
            // id 고유키는 따로 읽어옵니다.
            let id = sqlite3_column_int(statement, 0)
            
            // 출력형식을 만들어주고, 이미 읽어온 id만 초기화
            var d = StudyModel(id: Int(id), name: nil, done: nil, date: nil)
            // 받아온데이터를 data 딕셔너리에 먼저 넣고, 저장변수이름과 해당하는 값을 매칭시켜서 d에 저장합니다.
            var data = Dictionary<String, String>()
            for  i in 0..<column.count {
                data[column[i]] = String(cString: sqlite3_column_text(statement, Int32(i+1)))
                let load = String(cString: sqlite3_column_text(statement, Int32(i+1)))
                switch column[i] {
                case column[0]: d.name = load
                case column[1]: d.done = load
                case column[2]: d.date = load
                default: continue
                }
            }
            // 저장된 d를 출력배열 result에 넣습니다.
            result.append(d)
        }
        sqlite3_finalize(statement)
        return result
    }
    
    // 데이터 수정오류메세지
    private func onSQLErrorPrintErrorMessage(_ db: OpaquePointer?) {
        let errorMessage = String(cString: sqlite3_errmsg(db))
        print("Error preparing Update \(errorMessage)")
        return
    }

    func updateData(tableName: String, id: Int, done: String, date: String) {
        """
        데이터 수정도 역시나 쿼리를 구성한 후 실행하는 과정을 거칩니다.
        쿼리구성: UPDATE tablename SET name='변경값',date='변경값' WHERE id==2
        TEXT형식은 반드시 변경값에 ''를 감싸줘야합니다.
        WHERE뒤에는 조건부가 나옵니다.
        """
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

    func deleteData(tableName: String, id: Int) {
        """
        값 삭제도 쿼리를 구성후 실행합니다.
        데이터 변경과 비슷하게 조건부가 필요합니다.
        쿼리구성: delete from tablename where id == 2
        tablename이란 테이블에서 id(고유키)가 2인 데이터를 삭제한다.
        """
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



