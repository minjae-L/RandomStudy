//
//  HistoryViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/15.
//

import UIKit

class HistoryViewController: UIViewController {

    private var tableView = UITableView()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // UI 그리기
    func configureUI() {
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
        let num = Array(Set(FinishedList.sampleData.map{ $0.date})).count
        return num
    }
    // Section안의 cell의 개수
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        let date = Array(Set(FinishedList.sampleData.map{ $0.date!})).sorted()[section]
        return FinishedList.sampleData.filter{ $0.date == date}.count
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let str = String(Array(Set(FinishedList.sampleData.map{$0.date!})).sorted()[section])
        return str
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let date = Array(Set(FinishedList.sampleData.map{ $0.date!})).sorted()[indexPath.section]
        let finished = FinishedList.sampleData.filter{ $0.date == date}[indexPath.row]
        var arr = [CompletionList]()
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: HistoryTableViewCell.identifier,
            for: indexPath
        ) as? HistoryTableViewCell else {
            return UITableViewCell()
        }

        cell.configure(with: finished)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }

}
