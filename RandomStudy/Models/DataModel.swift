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
// MARK: - Singleton UserDefaults
class StudyListUserDefaults {
    var data :[Study] = {
        var arr = [Study]()
        if let data = UserDefaults.standard.value(forKey: "studyList") as? Data {
            arr = try! PropertyListDecoder().decode(Array<Study>.self, from: data)
        }
        return arr
    }() {
        didSet {
            UserDefaults.standard.setValue(try? PropertyListEncoder().encode(data), forKey: "studyList")
        }
    }
    static let shared = StudyListUserDefaults()
    private init(){}
    
    func add(new: Study) {
        data.append(new)
    }
    
    func remove(index: Int) {
        data.remove(at: index)
    }
    
    func set(new: [Study]) {
        data = new
    }
    func removeAll() {
        UserDefaults.standard.removeObject(forKey: "studyList")
    }
}

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
        UserDefaults.standard.removeObject(forKey: "todayStudy")
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
        UserDefaults.standard.removeObject(forKey: "completionStudy")
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


//
