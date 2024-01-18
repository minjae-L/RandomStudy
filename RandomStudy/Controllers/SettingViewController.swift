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
        settingUI()
    }
    
    private func settingUI() {
        // View
        self.view.backgroundColor = .white
        
        // NavigationBar
        self.navigationItem.title = "설정"
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        navBarAppearance.backgroundColor = .white
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
        
    }
    
    // 설정 목록
    private func configure() {
        // 일반
        models.append(Section(title: "일반", options: [
            .switchCell(model: SettingSwitchOption(title: "다크 모드",
                                                   icon: UIImage(systemName: "moon"),
                                                   iconBackgroundColor: .systemRed,
                                                   handler: {},
                                                   isOn: false)),
            .staticCell(model: SettingsOption(title: "내 기록",
                                              icon: UIImage(systemName: "checklist.checked"),
                                              iconBackgroundColor: .systemGreen,
                                              handler: {
                                                  let vc = HistoryViewController()
                                                  self.navigationController?.pushViewController(vc, animated: true)
            }))]
        ))
        
        // Git
        models.append(Section(title: "Git", options: [
            .staticCell(model: SettingsOption(title: "Git search",
                                              icon: UIImage(systemName: "magnifyingglass"),
                                              iconBackgroundColor: .black,
                                              handler: {}
            ))]
        ))
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
