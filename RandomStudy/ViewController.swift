//
//  ViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/06/05.
//

import UIKit


class ViewController: UIViewController {
    private var cellData = StudyServer.dataArray
    private var btn = UIButton()
    private var tableView = UITableView()
    
    private func addView() {
        view.addSubview(tableView)
        view.addSubview(btn)
        settingUI()
    }
    
    private func settingUI() {
        // View
        view.backgroundColor = .white
        
        // NavigationItem
        self.navigationItem.title = "Today"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSettingVC))
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.backgroundColor = .white
        
        // TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: btn.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true

        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodayTableViewCell.self, forCellReuseIdentifier: TodayTableViewCell.identifier)
        
        // Button
        btn.setTitle("Random", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        btn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellData = StudyServer.getData()
        tableView.reloadData()
    }
    
    @objc private func goSettingVC() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}

extension ViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if cellData.count == 0 {
            tableView.setEmptyView(title: "비어있음",
                                   message: "목록을 추가해주세요.")
        } else {
            tableView.restore()
        }
        return cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "studyCell", for: indexPath)
//        cell.textLabel?.text = cellData[indexPath.row].name
        let study = cellData[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodayTableViewCell.identifier,
            for: indexPath
        ) as? TodayTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: study)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
}

