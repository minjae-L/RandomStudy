//
//  HistoryViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/15.
//

import UIKit

class HistoryViewController: UIViewController {

    private var tableView = UITableView()
    private var viewModel = HistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(UIDarkmodeUserDefaults.shared.UIMode)
    }
    
    // UI 그리기
    private func configureUI(_ type: UIType) {
        let appearance = UINavigationBarAppearance()
        switch type {
        case .dark:
            view.backgroundColor = .black
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            appearance.backgroundColor = .black
            tableView.backgroundColor = .black
        case .normal:
            view.backgroundColor = .white
            appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
            appearance.backgroundColor = .white
            tableView.backgroundColor = .white
        }
        appearance.backgroundImage = UIImage()
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "내 기록"
        //addSubView
        view.addSubview(tableView)
        
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
    }
}

extension HistoryViewController:  UITableViewDelegate, UITableViewDataSource {
    // Section 개수
    func numberOfSections(in tableView: UITableView) -> Int {
        if viewModel.dateCount == 0 {
            tableView.setEmptyView(title: "비어있음", message: "오늘의 목표를 달성해보세요.")
        } else {
            tableView.restore()
        }
        return viewModel.dateCount
    }
    
    // Section안의 cell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let date = viewModel.dateArray[section]
        return viewModel.completions.filter{ $0.date == date}.count
    }
    
    // Section 타이틀 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(viewModel.dateArray[section])
    }
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let view = view as? UITableViewHeaderFooterView {
            switch UIDarkmodeUserDefaults.shared.UIMode {
            case .dark:
                view.textLabel?.textColor = .white
            case .normal:
                view.textLabel?.textColor = .gray
            }
        }
    }
    
    // Cell 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = viewModel.dateArray[indexPath.section]
        let finished = viewModel.completions.filter{ $0.date == date}[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryTableViewCell.identifier,
            for: indexPath
        ) as? HistoryTableViewCell else {
            return UITableViewCell()
        }
        cell.setUIColor(UIDarkmodeUserDefaults.shared.UIMode)
        cell.configure(with: finished)
        return cell
    }
    
    // Cell 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

}
