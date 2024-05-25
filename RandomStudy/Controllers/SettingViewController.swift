//
//  SettingViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/14.
//

import UIKit
import FirebaseAuth

// MARK: - Main
class SettingViewController: UIViewController {
    
    // 두가지 Custom Cell을 선언과 동시에 등록한다.
    private let tableView: UITableView = {
        let table = UITableView(frame: .zero, style: .grouped)
        table.register(SettingTableViewCell.self, forCellReuseIdentifier: SettingTableViewCell.identifier)
        table.register(SwitchTableViewCell.self, forCellReuseIdentifier: SwitchTableViewCell.identifier)
        table.separatorStyle = .none
        
        return table
    }()
    private var models = [Section]()
    private let appearance = UINavigationBarAppearance()
    private func addSubView() {
        view.addSubview(tableView)
        settingUI()
    }
    
    private func settingUI() {
        self.view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "LabelTextColor")]
        appearance.backgroundColor = UIColor(named: "ViewBackgroundColor")
        // NavigationBar
        self.navigationItem.title = "설정"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.largeTitleDisplayMode = .never
            
        // TableView
        tableView.backgroundColor = UIColor(named: "ViewBackgroundColor")
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
    override func viewWillAppear(_ animated: Bool) {
        settingUI()
    }
    // 설정 목록
    private func configure() {
        // 일반
        models.append(Section(title: "일반", options: [
            .staticCell(model: SettingsOption(title: "테마 설정",
                                              icon: UIImage(systemName: "moon"),
                                              iconBackgroundColor: .systemPurple,
                                              handler: {
                                                  let vc = DarkModeSettingViewController()
                                                  self.navigationController?.pushViewController(vc, animated: true)
                                              },
                                              accessoryType: .none)),
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
        models.append(Section(title: "", options: [
            .staticCell(model: SettingsOption(title: "로그아웃",
                                              icon: nil,
                                              iconBackgroundColor: .clear,
                                              handler: {
                                                  do {
                                                      try Auth.auth().signOut()
                                                      self.showReConfirmAlert("정말 로그아웃하시겠습니까?") { confirm in
                                                          if confirm {
                                                              self.navigationController?.popToRootViewController(animated: false)
                                                              self.view.window!.rootViewController?.dismiss(animated: true, completion: nil)
                                                          }
                                                      }
                                                  }catch {
                                                      print("logout fail")
                                                  }
                                              },
                                              accessoryType: .none
                                             ))]))
    }
    
    private func removeAllButtonEvent() {
        FirebaseManager.shared.removeFirebaseData()
        self.showMessageAlert("초기화 되었습니다.")
    }

}
// MARK: Switch Button Action
extension SettingViewController: SwitchTableViewCellDelegate {
    func changedViewMode() {
        print("settingVC delegate")
        DispatchQueue.main.async { [weak self] in
            self?.settingUI()
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
            headerView.textLabel?.textColor = UIColor(named: "LabelTextColor")
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
            
            cell.setUIColor()
            cell.configure(with: model)
            return cell
        case .switchCell(var model):
            guard let cell = tableView.dequeueReusableCell(
                    withIdentifier: SwitchTableViewCell.identifier,
                    for: indexPath
            ) as? SwitchTableViewCell else {
                return UITableViewCell()
            }
            cell.setUIColor()
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
