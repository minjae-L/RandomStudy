//
//  StudyData.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/13.
//

import Foundation
import UIKit

// MARK: - Model
struct StudyModel: Equatable, Codable {
    var id: Int?
    var name: String?
    var done: String?
    var date: String?
    
    static func ==(lhs: StudyModel, rhs: StudyModel) -> Bool {
        return lhs.name == rhs.name
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
    
    static func ==(lhs: CompletionList, rhs: CompletionList) -> Bool {
        return lhs.name == rhs.name && lhs.date == rhs.date
    }
}


// TodayVC의 데이터 현황
enum DateState {
    case empty
    case finish
    case loading
}
// GitSearch 데이터 모델
struct GitSearchRepository: Codable {
    let repositoryItems: [GitSearchItems]
    
    enum CodingKeys: String, CodingKey {
        case repositoryItems = "items"
    }
}

struct GitSearchItems: Codable {
    let fullName: String?
    let description: String?
    let htmlUrl: String?
    let gitUser: GitUser
    
    enum CodingKeys: String, CodingKey {
        case fullName = "full_name"
        case description
        case htmlUrl = "html_url"
        case gitUser = "owner"
    }
}
struct GitUser: Codable {
    let avatarUrl: String?
    
    enum CodingKeys: String, CodingKey {
        case avatarUrl = "avatar_url"
    }
}
// MARK: - Singleton UserDefaults

class TodayStudyUserDefauls {
    var data: [TodayStudyList] = {
        var arr = [TodayStudyList]()
        if let data = UserDefaults.standard.value(forKey: "todayStudy") as? Data {
            arr = try! PropertyListDecoder().decode(Array<TodayStudyList>.self, from: data)
        }
        return arr
    }() {
        didSet {
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(data), forKey: "todayStudy")
        }
    }
    static let shared = TodayStudyUserDefauls()
    private init() {}
    
    func set(new: [TodayStudyList]) {
        data = new
    }
    func removeAll() {
        data.removeAll()
    }
}

class HistoryUserDefaults {
    var data: [CompletionList] = {
        var arr = [CompletionList]()
        if let data = UserDefaults.standard.value(forKey: "completionStudy") as? Data {
            arr = try! PropertyListDecoder().decode(Array<CompletionList>.self, from: data)
        }
        return arr
    }() {
        didSet {
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(data), forKey: "completionStudy")
        }
    }
    static let shared = HistoryUserDefaults()
    private init() {}
    
    func set(new: [CompletionList]) {
        data = new
    }
    func removeAll() {
        data.removeAll()
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
    let accessoryType: UITableViewCell.AccessoryType
}
