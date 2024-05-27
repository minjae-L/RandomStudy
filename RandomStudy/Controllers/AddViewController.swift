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
        let appearance = UINavigationBarAppearance()
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        //NavigationBar
        self.navigationItem.title = "공부 목록"
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "LabelTextColor")]
        appearance.backgroundColor = UIColor(named: "ViewBackgroundColor")
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "plus"), style: .plain, target: self, action: #selector(addCategory))
        
        // TableView
        tableView.separatorStyle = .none
        tableView.backgroundColor = UIColor(named: "ViewBackgroundColor")
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
        let addPopUpView = AddPopUpViewController()
        addPopUpView.delegate = self
        addPopUpView.modalPresentationStyle = .overFullScreen
        addPopUpView.modalTransitionStyle = .crossDissolve
        self.present(addPopUpView, animated: true, completion: nil)
    }
    
}
// MARK: Delegates
extension AddViewController: AddPopUpViewControllerDelegate {
    func sendedDataFromPopUp() {
        viewModel.fetchData()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}

extension AddViewController: AddViewControllerButtonDelegate {
    func cellDeleteButtonTapped(name: String) {
        viewModel.removeData(name: name)
    }
}
extension AddViewController: AddViewModelDelegate {
    func didUpdate(with value: [FirebaseDataModel]) {
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
        cell.setUIColor()
        cell.selectionStyle = .none
        cell.delegate = self
        cell.configure(with: study)

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}



