//
//  AddViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/04.
//

import UIKit


class AddViewController: UIViewController {
    
    private var study = StudyServer.dataArray {
        didSet {
            StudyServer.dataArray = study
            print("didset \(StudyServer.getData())")
            tableView.reloadData()
        }
    }
    private var tableView = UITableView()
    
    private func addSubView() {
        view.addSubview(tableView)
        settingUI()
        
    }
    
    private func settingUI() {
        //NavigationBar
        self.view.backgroundColor = .white
        self.navigationItem.title = "add"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(addCategory))
        
        // TableView
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "studyCell")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
        
    }
    
    @objc func addCategory() {
        let alert = UIAlertController(title: "추가하기", message: "", preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "추가", style: .default) { (yes) in
            self.study.append(Study(name: alert.textFields?[0].text))
        }
        addAction.isEnabled = false
        
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField() { (textField) in
            textField.addTarget(alert, action: #selector(alert.checkTextFieldBlank(_:)), for: UIControl.Event.editingChanged)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
}

// 테이블 뷰
extension AddViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return study.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "studyCell", for: indexPath)
        cell.textLabel?.text = study[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
}

// 텍스트필드 공백 검사
extension UIAlertController {
    @objc func checkTextFieldBlank(_ sender: UITextField) {
        if (sender.text?.count == 0) {
            self.actions[0].isEnabled = false
        } else {
            self.actions[0].isEnabled = true
        }
    }
}

