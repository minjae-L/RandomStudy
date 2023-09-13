//
//  StudyData.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/13.
//

import Foundation

struct Study {
    let name: String?
}

class StudyServer {
    static var dataArray = [Study]()
    
    static func getData() -> [Study] {
        if dataArray.isEmpty {
            return [Study(name: "비어있습니다.")]
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
