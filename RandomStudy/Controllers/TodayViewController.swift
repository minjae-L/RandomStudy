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
    private var viewModel = ObservableTodayViewModel()
    private var historyViewModel = ObservableHistoryViewModel()
    
    private func bindings() {
        viewModel.todayStudy.bind{ [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
            viewModel.userdefaultsDataSet()
        }
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
        btn.addTarget(self, action: #selector(uploadStudyList), for: .touchUpInside)
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
    @objc private func uploadStudyList() {
        let alert = UIAlertController(title: "알림", message: "불러올 목록이 없습니다.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "확인", style: .cancel)
        alert.addAction(okAction)
        switch viewModel.checkUploadData() {
        case 0:
            alert.message = "불러올 목록이 없습니다."
        case 1:
            alert.message = "이미 모든 목록을 불러왔습니다."
        case 2:
            alert.message = "불러오기 완료."
            viewModel.uploadData()
            print(viewModel.todayStudy.value)
            print(viewModel.studyList)
        default: break
        }
        self.present(alert, animated: true, completion: nil)
    }
}

extension TodayViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.studyList.count == 0 {
            tableView.setEmptyView(title: "비어있음",
                                   message: "목록을 추가해주세요.")
        } else {
            tableView.restore()
        }
        return viewModel.studyList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let study = viewModel.todayStudy.value[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodayTableViewCell.identifier,
            for: indexPath
        ) as? TodayTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: study)
        cell.deleteBtn.tag = indexPath.row
        cell.checkBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)
        cell.checkBtn.addTarget(self, action: #selector(checkBtnTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        
        // 완료시 배경색 변경 및 체크표시
        print(study)
        print(cell)
        if study.isDone {
            cell.backgroundColor = .lightGray
            cell.checkView.isHidden = false
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    // 삭제버튼 이벤트
    @objc func deleteBtnTapped(sender: UIButton) {
        viewModel.remove(index: sender.tag)
    }
    // 완료버튼 이벤트
    @objc func checkBtnTapped(sender: UIButton) {
        let point = sender.convert(CGPoint.zero, to: tableView)
        guard let indexPath = tableView.indexPathForRow(at: point) else { return }
        guard let cell = tableView.cellForRow(at: indexPath) else { return }
        
        // 완료된 데이터 전달
        let name = viewModel.studyList[sender.tag].name!
        let date = viewModel.studyList[sender.tag].date!
        if !historyViewModel.isContainElement(name: name, date: date) {
            historyViewModel.addData(name: name,
                                     date: date)
            historyViewModel.userdefaultsDataSet()
        }
        
        // Lottie 애니메이션 실행
        let animationView: LottieAnimationView = {
            let view = LottieAnimationView(name: "check")
            view.translatesAutoresizingMaskIntoConstraints = false
            view.widthAnchor.constraint(equalToConstant: 80).isActive = true
            view.heightAnchor.constraint(equalToConstant: 80).isActive = true
            
            return view
        }()
        
        cell.addSubview(animationView)
        animationView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        animationView.play{(finish) in
            animationView.removeFromSuperview()
            self.viewModel.complete(index: sender.tag)
        }
        
    }
}

