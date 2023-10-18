//
//  StudyData.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/13.
//

import Foundation
import UIKit

// MARK: - Model
struct Study: Equatable, Codable {
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
struct TodayStudyList: Equatable, Codable {
    let name: String?
    var isDone: Bool
    let date: String?
}

struct CompletionList: Equatable, Codable {
    let name: String?
    let date: String?
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
