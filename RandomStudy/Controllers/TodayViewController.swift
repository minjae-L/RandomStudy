//
//  ViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/06/05.
//

import UIKit

final class TodayViewController: UIViewController {
    // UI 선언
    private let btn = UIButton()
    private let tableView = UITableView()
    // 뷰모델 선언 및 데이터 바인딩
    private let viewModel = TodayViewModel()
    private func bindings() {
        viewModel.delegate = self
    }

    // UI 넣기
    private func addView() {
        view.addSubview(tableView)
        view.addSubview(btn)
    }
    private func isPreviousDataExist() {
        if Firebase.shared.isDataExist() {
            let vc = DataMigrationViewController()
            vc.delegate = self
            vc.modalPresentationStyle = .overFullScreen
            vc.modalTransitionStyle = .crossDissolve
            self.present(vc,animated: true)
        }
    }
//    MARK: - UI Configure
    // 네비게이션 바
    private func configureNavigationbar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "LabelTextColor")]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "LabelTextColor")]
        appearance.backgroundColor = UIColor(named: "ViewBackgroundColor")
        appearance.backgroundImage = UIImage()
        appearance.shadowImage = UIImage()
        self.navigationItem.title = "Today"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.rightBarButtonItems = [UIBarButtonItem(image: UIImage(systemName: "gearshape"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(goSettingVC)),
                                                   UIBarButtonItem(image: UIImage(systemName: "plus"),
                                                                   style: .plain,
                                                                   target: self,
                                                                   action: #selector(goAddVC))
        ]
    }

    // 전체적인 화면 구성
    private func settingUI() {
        self.navigationController?.view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        tableView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        // TableView
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tableView.bottomAnchor.constraint(equalTo: btn.topAnchor).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.allowsSelection = false
        tableView.register(TodayTableViewCell.self, forCellReuseIdentifier: TodayTableViewCell.identifier)
        
        // Button
        btn.setTitle("불러오기", for: .normal)
        btn.backgroundColor = .systemBlue
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.heightAnchor.constraint(equalToConstant: 80).isActive = true
        btn.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        btn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        btn.addTarget(self, action: #selector(fetchStudyList), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        bindings()
        isPreviousDataExist()
        print("TodayVC:: todd: \(viewModel.todo)")
    }
    override func viewWillAppear(_ animated: Bool) {
        viewModel.fetchData()
        settingUI()
        configureNavigationbar()
    }
    
    @objc private func goSettingVC() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @objc private func goAddVC() {
        let vc = AddViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 불러오기 버튼 이벤트
    @objc private func fetchStudyList() {
        viewModel.uploadStudy()
    }
}
// MARK: - Cell Button Action
extension TodayViewController: TodayTableViewCellDelegate {
    func deleteButtonTapped(name: String) {
        viewModel.remove(name: name)
    }
    
    func checkButtonTapped(name: String) {
        viewModel.complete(name: name)
    }
}

// MARK: - TableView
extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
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
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodayTableViewCell.identifier,
            for: indexPath
        ) as? TodayTableViewCell else {
            return UITableViewCell()
        }
        
        let study = viewModel.todo[indexPath.row]
        print("study: \(study)")
        cell.setUIColor()
        cell.delegate = self
        cell.configure(with: study)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
}

// MARK: - ViewModel Delegate
extension TodayViewController: TodayViewModelDelegate {
    func didUpdateToday() {
        print("didUpdateToday")
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}


extension TodayViewController: DataMigrationViewControllerDelegate {
    func didTappedInitialData() {
        self.viewModel.fetchData()
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
}
