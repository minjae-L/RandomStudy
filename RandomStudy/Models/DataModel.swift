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
// MARK: Dark mode
enum UIType {
    case dark
    case normal
}
class UIDarkmodeUserDefaults {
    var isDark: Bool = UserDefaults.standard.bool(forKey: "darkMode") {
        didSet {
            UserDefaults.standard.setValue(self.isDark, forKey: "darkMode")
            fetchMode()
        }
    }
    
    static let shared = UIDarkmodeUserDefaults()
    private init(){}
    
    var UIMode: UIType = {
        let dark = UserDefaults.standard.bool(forKey: "darkMode")
        if dark {
            return .dark
        } else {
            return .normal
        }
    }()
    private func fetchMode() {
        switch self.isDark {
        case true: self.UIMode = .dark
        case false: self.UIMode = .normal
        default:
            break
        }
    }
    func changeMode() {
        self.isDark = !isDark
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
