//
//  DarkModeSettingViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 5/6/24.
//

import Foundation
import UIKit

// MARK: Dark mode
enum DarkMode {
    case dark
    case light
    case custom
}
struct ModeOptions {
    let title: String
    let mode: DarkMode
}
class DarkModeSettingViewModel {
    var options: [ModeOptions] = [ModeOptions(title: "사용자 지정", mode: .custom), ModeOptions(title: "라이트 모드", mode: .light), ModeOptions(title: "다크 모드", mode: .dark)]
    
    func changeMode(_ options: ModeOptions) {
        guard let vc = UIApplication.shared.windows.first else { return }
        
        switch options.mode {
        case .custom:
            vc.overrideUserInterfaceStyle = .unspecified
        case .dark:
            vc.overrideUserInterfaceStyle = .dark
        case .light:
            vc.overrideUserInterfaceStyle = .light
        }
        UIModeUserDefaults.shared.chageValue(options.mode)
    }
}
class UIModeUserDefaults {
    static let shared = UIModeUserDefaults()
    init() {}
    // 저장된 값으로 초기화
    // 한번도 값이 설정되지 않았다면 nil
    var stringValue = UserDefaults.standard.string(forKey: "mode")
    
    // 저장된 값을 UIMode 형식으로 저장
    // 한번도 값이 설정되지 않았다면 default를 통해 .custom으로 지정(사용자지정모드)
    var modeValue: DarkMode {
        switch self.stringValue {
        case "custom":
            return .custom
        case "dark":
            return .dark
        case "light":
            return .light
        default:
                return .custom
        }
    }
    // 값 변경후 value 갱신
    func chageValue(_ mode: DarkMode) {
        print(mode)
        switch mode {
        case .dark:
            UserDefaults.standard.setValue("dark", forKey: "mode")
        case .light:
            UserDefaults.standard.setValue("light", forKey: "mode")
        case .custom:
            UserDefaults.standard.setValue("custom", forKey: "mode")
        }
        stringValue = UserDefaults.standard.string(forKey: "mode")
    }
}
