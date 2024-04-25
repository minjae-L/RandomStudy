//
//  SettingViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/14.
//

import UIKit

// MARK: - Main
class SettingViewController: UIViewController {
    
    // 두가지 Custom Cell을 선언과 동시에 등록한다.
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        return table
    }()
    private var models = [Section]()
    private func addSubView() {
        view.addSubview(tableView)
        settingUI(UIDarkmodeUserDefaults.shared.UIMode)
    }
    
    private func settingUI(_ type: UIType) {
        let navBarAppearance = UINavigationBarAppearance()
        switch type {
        case .dark:
            self.view.backgroundColor = .black
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            navBarAppearance.backgroundColor = .black
            tableView.backgroundColor = .black
        case .normal:
            self.view.backgroundColor = .white
            navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            navBarAppearance.backgroundColor = .white
            tableView.backgroundColor = UIColor.lightGray.withAlphaComponent(0.2)
        }
        // View
        
        
        // NavigationBar
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = navBarAppearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        self.navigationItem.largeTitleDisplayMode = .never
        
        // TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        configure()
        settingUI(UIDarkmodeUserDefaults.shared.UIMode)
    }
    
    // 설정 목록
    private func configure() {
        
        // 일반
        models.append(Section(title: "일반", options: [
            .switchCell(model: SettingSwitchOption(title: "다크 모드",
                                                   icon: UIImage(systemName: "moon"),
                                                   iconBackgroundColor: .systemPurple,
                                                   handler: {},
                                                   isOn: UIDarkmodeUserDefaults.shared.isDark
                                                   )),
            .staticCell(model: SettingsOption(title: "내 기록",
                                              icon: UIImage(systemName: "checklist.checked"),
                                              iconBackgroundColor: .systemGreen,
                                              handler: {
                                                    let vc = HistoryViewController()
                                                    self.navigationController?.pushViewController(vc, animated: true)
                                                    },
                                              accessoryType: .disclosureIndicator
                                              ))
        ]))
        
        // Git
        models.append(Section(title: "Git", options: [
            .staticCell(model: SettingsOption(title: "Git search",
                                              icon: UIImage(systemName: "magnifyingglass"),
                                              iconBackgroundColor: .black,
                                              handler: {
                                                  self.navigationController?.pushViewController(GitSearchViewController(), animated: true)
                                              },
                                              accessoryType: .none
            ))]
        ))
        models.append(Section(title: "초기화", options: [
            .staticCell(model: SettingsOption(title: "기록 초기화",
                                              icon: UIImage(systemName: "trash"),
                                              iconBackgroundColor: .systemRed,
                                              handler: {
                                                  self.removeAllButtonEvent()
                                                },
                                              accessoryType: .none
                                             ))]))
    }
    
    private func removeAllButtonEvent() {
        let alert = UIAlertController(title: "초기화", message: "초기화하였습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .default)
        alert.addAction(okAction)
        self.present(alert, animated: true)
        DBHelper.shared.resetAllTable()
    }

}
// MARK: Switch Button Action
extension SettingViewController: SwitchTableViewCellDelegate {
    func changedViewMode() {
        print("settingVC delegate")
        DispatchQueue.main.async { [weak self] in
            self?.settingUI(UIDarkmodeUserDefaults.shared.UIMode)
            self?.tableView.reloadData()
        }
    }
}


// MARK: TableView Extension
extension SettingViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let model = models[section]
        return model.title
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView {
            headerView.textLabel?.font = .boldSystemFont(ofSize: 15)
            if UIDarkmodeUserDefaults.shared.isDark {
                headerView.textLabel?.textColor = .lightGray
            } else {
                headerView.textLabel?.textColor = .black
            }
        }
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
            
            cell.backgroundView = nil
            cell.backgroundColor = .clear
            cell.setUIColor(UIDarkmodeUserDefaults.shared.UIMode)
            cell.configure(with: model)
            return cell
        case .switchCell(let model):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SwitchTableViewCell.identifier,
                    for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.backgroundView = nil
            cell.backgroundColor = .clear
            cell.setUIColor(UIDarkmodeUserDefaults.shared.UIMode)
            cell.delegate = self
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
