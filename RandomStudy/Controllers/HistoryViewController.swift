//
//  HistoryViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/15.
//

import UIKit

class HistoryViewController: UIViewController {

    private var tableView = UITableView()
    private var viewModel = ObservableHistoryViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
        bindings()
    }
    
    // 데이터 바인딩
    private func bindings() {
        viewModel.completionStudy.bind{ [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    // UI 그리기
    private func configureUI() {
        //addSubView
        view.addSubview(tableView)
        //View
        view.backgroundColor = .white
        
        //NavigationBar
        self.navigationItem.title = "내 기록"
        
        //TableView
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(HistoryTableViewCell.self, forCellReuseIdentifier: HistoryTableViewCell.identifier)
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
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
        return viewModel.completionList.filter{ $0.date == date}.count
    }
    
    // Section 타이틀 설정
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return String(viewModel.dateArray[section])
    }
    
    // Cell 구성
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let date = viewModel.dateArray[indexPath.section]
        let finished = viewModel.completionList.filter{ $0.date == date}[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryTableViewCell.identifier,
            for: indexPath
        ) as? HistoryTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: finished)
        return cell
    }
    
    // Cell 높이
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
