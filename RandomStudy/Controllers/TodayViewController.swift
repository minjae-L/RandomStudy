//
//  ViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/06/05.
//

import UIKit
import Lottie

class TodayViewController: UIViewController {
    
    // UI 선언
    private var btn = UIButton()
    private var tableView = UITableView()
    
    // 뷰모델 선언 및 데이터 바인딩
    private var viewModel = TodayViewModel()
    
    private func bindings() {
        viewModel.todayDelegate = self
        viewModel.historyDelegate = self
    }
    // 하루가 지났는지 파악하는 메소드
    private var dateFommatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "YYYY년MM월dd일"
        
        return dateFormatter
    }()
    
    private func isDayChanged() -> Bool {
        let todayDate = dateFommatter.string(from: Date())
        let userDefaultsDate = UserDefaults.standard.value(forKey: "todayDate")
        if userDefaultsDate == nil {
            UserDefaults.standard.set(todayDate, forKey: "todayDate")
            return false
        } else if todayDate != userDefaultsDate as! String {
            UserDefaults.standard.set(todayDate, forKey: "todayDate")
            return true
        }
        return false
    }
    
    // UI 넣기
    private func addView() {
        view.addSubview(tableView)
        view.addSubview(btn)
        settingUI()
    }
    
    // 네비게이션 바
    private func configureNavigationbar() {
        let appearance = UINavigationBarAppearance()
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.black]
        appearance.configureWithTransparentBackground()
        appearance.backgroundColor = .white
        self.navigationItem.title = "Today"
        self.navigationController?.navigationBar.prefersLargeTitles = true
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.largeTitleDisplayMode = .always
        
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "gearshape"), style: .plain, target: self, action: #selector(goSettingVC))
    }
    
    // 전체적인 화면 구성
    private func settingUI() {
        // View
        view.backgroundColor = .white
        
        // NavigationItem
        configureNavigationbar()
        
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
        btn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        btn.topAnchor.constraint(equalTo: tableView.bottomAnchor).isActive = true
        btn.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        btn.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        btn.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        btn.addTarget(self, action: #selector(fetchStudyList), for: .touchUpInside)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        bindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        configureNavigationbar()
        // 하루가 지났는지 확인
        if self.isDayChanged() {
            let alert = UIAlertController(title: "새로운 하루", message: "목록이 초기화 되었습니다.", preferredStyle: .alert)
            let okAction = UIAlertAction(title: "확인", style: .cancel)
            alert.addAction(okAction)
            viewModel.removeAll()
        }

    }
    
    @objc private func goSettingVC() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 불러오기 버튼 이벤트
    @objc private func fetchStudyList() {
        let alert = UIAlertController(title: "알림", message: "불러올 목록이 없습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(okAction)
        switch viewModel.checkDataState() {
        case .empty:
            alert.message = "불러올 목록이 없습니다."
        case .finish:
            alert.message = "이미 모든 목록을 불러왔습니다."
        case .loading:
            alert.message = "불러오기 완료."
            viewModel.fetchData()
        default: break
        }
        self.present(alert, animated: true, completion: nil)
    }
}
// MARK: - Cell Button Action
extension TodayViewController: TodayTableViewCellDelegate {
    // 체크버튼 액션
    func checkButtonTapped(value: TodayStudyList?) {
        let element = CompletionList(name: value?.name, date: value?.date)
        if !viewModel.isContainElement(element) {
            viewModel.completions.append(element)
        }
        let completionElement = TodayStudyList(name: value?.name,
                                               isDone: true,
                                               date: value?.date)
        guard let firstIndex = viewModel.todayStudy.firstIndex(where: { $0.name == completionElement.name }) else { return }
        viewModel.todayStudy[firstIndex] = completionElement
    }
    
    // 삭제버튼 액션
    func deleteButtonTapped(value: TodayStudyList?) {
        viewModel.remove(item: value)
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
        
        let study = viewModel.todayStudy[indexPath.row]
        
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
    func didUpdateToday(with value: [TodayStudyList]) {
        TodayStudyUserDefauls.shared.set(new: value)
        DispatchQueue.main.async { [weak self] in
            self?.tableView.reloadData()
        }
    }
    
    func didUpdateHistory(with value: [CompletionList]) {
        HistoryUserDefaults.shared.set(new: value)
    }
    
}
