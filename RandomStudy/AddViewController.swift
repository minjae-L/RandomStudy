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
        self.navigationItem.title = "공부 목록"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.barTintColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCategory))
        
        // TableView
        tableView.separatorStyle = .none
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(AddTableViewCell.self, forCellReuseIdentifier: AddTableViewCell.identifier)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addSubView()
    }
    
    @objc func addCategory() {
        
        let alert = UIAlertController(title: "추가하기", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "추가", style: .default) { (addAction) in
            guard let text = alert.textFields?[0].text else { return }
            if !self.isContainsElement(str: text) {
                self.study.append(Study(name: alert.textFields?[0].text))
            }
        }
        let cancelAction = UIAlertAction(title: "취소", style: .cancel)
        
        addAction.isEnabled = false
        alert.addAction(addAction)
        alert.addAction(cancelAction)
        alert.addTextField() { (textField) in
            textField.becomeFirstResponder()
            textField.returnKeyType = .done
            textField.addTarget(alert, action: #selector(alert.checkTextFieldBlank(_:)), for: UIControl.Event.editingChanged)
        }
        self.present(alert, animated: true, completion: nil)
    }
    
    private func isContainsElement(str: String) -> Bool {
        var isContain = false
        for i in 0..<study.count {
            if study[i].name == str {
                isContain = true
                break
            }
        }
        return isContain
    }
    
}

// 테이블 뷰
extension AddViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if study.count == 0 {
            tableView.setEmptyView(title: "비어있음",
                                   message: "목록을 추가해주세요.")
        } else {
            tableView.restore()
        }
        return study.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let study = study[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AddTableViewCell.identifier,
            for: indexPath
        ) as? AddTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: study)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(tappedDeleteBtn(sender:)), for: .touchUpInside)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc func tappedDeleteBtn(sender: UIButton) {
        study.remove(at: sender.tag)
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

