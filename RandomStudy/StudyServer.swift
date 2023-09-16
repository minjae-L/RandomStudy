//
//  StudyData.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/13.
//

import Foundation

struct Study: Equatable {
    let name: String?
    
    static func ==(lhs: Study, rhs: Study) -> Bool {
        return lhs.name == rhs.name
    }
}

class StudyServer {
    static var dataArray = [Study]()
    
    static func getData() -> [Study] {
        if dataArray.isEmpty {
            return []
        } else {
            return dataArray
        }
    }
    static func addData(str: String?) {
        guard let data = str else { return }
        if data == "" { return }
        dataArray.append(Study(name: data))
    }
    
    static func setData(arr: [Study]?) {
        guard let data = arr else { return }
        dataArray = data
    }
}
