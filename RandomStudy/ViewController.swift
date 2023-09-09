//
//  ViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/06/05.
//

import UIKit


class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var cellData = StudyServer.getData()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        cellData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyCell", for: indexPath)
        cell.textLabel?.text = cellData[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    var tableView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        // NavigationBar
        self.navigationItem.title = "Today"
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(goAddVC))
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationItem.largeTitleDisplayMode = .always
        self.navigationController?.navigationBar.backgroundColor = .white
        
        
        // TableView
        tableView = UITableView()
        view.addSubview(tableView)
//        tableView.backgroundColor = .red
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "studyCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellData = StudyServer.getData()
        tableView.reloadData()
    }
    
    @objc private func goAddVC() {
        let vc = AddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
        
    }

}
