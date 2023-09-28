//
//  StudyData.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/13.
//

import Foundation
import UIKit

// MARK: - Model
struct Study: Equatable {
    let name: String?
    
    static func ==(lhs: Study, rhs: Study) -> Bool {
        return lhs.name == rhs.name
    }
}

extension Study {
    init(study: Study) {
        self.name = study.name
    }
}

// 따로 배열을 저장해둘곳
class Database {
    static var data = [Study]()
}

// 곧 지울꺼..
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

// MARK: - Setting ViewController Cell Struct
struct Section {
    let title: String
    let options: [SettingsOptionType]
}

enum SettingsOptionType {
    case staticCell(model: SettingsOption)
    case switchCell(model: SettingSwitchOption)
}

struct SettingSwitchOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (()-> Void)
    var isOn: Bool
}

struct SettingsOption {
    let title: String
    let icon: UIImage?
    let iconBackgroundColor: UIColor
    let handler: (()-> Void)
}
