//
//  AddViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/04.
//

import UIKit

// MARK: - 뷰 컨트롤러
class AddViewController: UIViewController {
    
    // 뷰모델 선언
    private var tableView = UITableView()
    private var viewModel = AddViewModel()
    
    private func addSubView() {
        view.addSubview(tableView)
        settingUI()
    }
    
    // 데이터 바인딩
    private func bindings() {
        viewModel.delegate = self
    }
    
    // UI 설정
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
        bindings()
    }
    
    
    // 추가하기 버튼 이벤트
    @objc func addCategory() {
        let alert = UIAlertController(title: "추가하기", message: "", preferredStyle: .alert)
        let addAction = UIAlertAction(title: "추가", style: .default) { (addAction) in
            guard let text = alert.textFields?[0].text else { return }
            if !self.viewModel.isContainsElement(str: text) {
                self.viewModel.addData(str: text)
            } else {
                let errorAlert = UIAlertController(title: "오류", message: "같은 목록이 이미 있습니다.", preferredStyle: .alert)
                let okAction = UIAlertAction(title: "확인", style: .default)
                errorAlert.addAction(okAction)
                self.present(errorAlert, animated: true)
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
    
}
// cell Button Action
extension AddViewController: AddViewControllerButtonDelegate {
    func cellDeleteButtonTapped(index: Int) {
        viewModel.removeData(index: index)
    }
}
extension AddViewController: AddViewModelDelegate {
    func didUpdate(with value: [Study]) {
        StudyListUserDefaults.shared.set(new: value)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
// MARK: - 테이블 뷰
extension AddViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.dataCount == 0 {
            tableView.setEmptyView(title: "비어있음",
                                   message: "목록을 추가해주세요.")
        } else {
            tableView.restore()
        }
        return viewModel.dataCount
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let study = viewModel.study[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AddTableViewCell.identifier,
            for: indexPath
        ) as? AddTableViewCell else {
            return UITableViewCell()
        }
        cell.selectionStyle = .none
        cell.index = indexPath.row
        cell.delegate = self
        cell.configure(with: study)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
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

