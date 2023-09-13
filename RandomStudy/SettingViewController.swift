//
//  SettingViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/14.
//

import UIKit

// MARK: - Cell Struct
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


// MARK: - Main
class SettingViewController: UIViewController {

    // 두가지 Custom Cell을 선언과 동시에 등록한다.
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    
    var models = [Section]()
    
    private func addSubView() {
        view.addSubview(tableView)
        settingUI()
    }
    
    private func settingUI() {
        // View
        self.view.backgroundColor = .white
        
        // NavigationBar
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.largeTitleDisplayMode = .never
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.frame = view.bounds
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        configure()
        
    }
    
    // Setting List
    func configure() {
        models.append(Section(title: "일반", options: [
            .switchCell(model: SettingSwitchOption(title: "다크 모드", icon: UIImage(systemName: "moon"), iconBackgroundColor: .systemRed, handler: {
                
            }, isOn: false)),
            .staticCell(model: SettingsOption(title: "공부 목록", icon: UIImage(systemName: "list.star"), iconBackgroundColor: .systemPink) {
                let vc = AddViewController()
                self.navigationController?.pushViewController(vc, animated: true)
            })
        ]))
    }

}


extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = models[section]
        return model.title
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return models.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return models[section].options.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = models[indexPath.section].options[indexPath.row]
        
        switch model.self {
        case .staticCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SettingTableViewCell.identifier,
                    for: indexPath
            ) as? SettingTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SwitchTableViewCell.identifier,
                    for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.configure(with: model)
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let model = models[indexPath.section].options[indexPath.row]
        switch model.self {
        case .staticCell(let model):
            model.handler()
        case .switchCell(let model):
            model.handler()
        }
    }
    
    
}
