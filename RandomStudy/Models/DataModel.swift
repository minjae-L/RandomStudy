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
// 오늘의 할일 모델
struct TodayStudyList: Equatable {
    let name: String?
    var isDone: Bool?
    let date: String?
}

struct CompletionList: Equatable {
    let name: String?
    let date: String?
}

// 공부목록이 저장된곳
class Database {
    static var data = [Study]()
}

// 오늘 해야할 공부목록을 저장한곳

// 공부완료된 목록들을 저장한곳
class FinishedList {
    static var data = [CompletionList]()
    static var sampleData = [CompletionList(name: "1", date: "2023년09월10일"),
                             CompletionList(name: "2-1", date: "2023년09월20일"),
                             CompletionList(name: "2-2", date: "2023년09월20일"),
                             CompletionList(name: "3-1", date: "2023년10월17일"),
                             CompletionList(name: "3-2", date: "2023년10월17일"),
                             CompletionList(name: "3-3", date: "2023년10월17일"),
                             CompletionList(name: "4-1", date: "2023년10월20일"),
                             CompletionList(name: "4-2", date: "2023년10월20일"),
                             CompletionList(name: "4-3", date: "2023년10월20일"),
                             CompletionList(name: "4-4", date: "2023년10월20일")
                            ]
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
