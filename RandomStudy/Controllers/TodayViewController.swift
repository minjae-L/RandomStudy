//
//  ViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/06/05.
//

import UIKit
import Lottie

class TodayViewController: UIViewController {
    
    // 뷰모델 선언 및 데이터 바인딩
    private var viewModel = ObservableTodayViewModel()
    private var historyViewModel = ObservableHistoryViewModel()
    private func bindings() {
        viewModel.todayStudy.bind{ [weak self] _ in
            guard let self = self else { return }
            self.tableView.reloadData()
        }
    }
    
    let animationView: LottieAnimationView = {
        let view = LottieAnimationView(name: "check")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        
        return view
    }()
    
    private var btn = UIButton()
    private var tableView = UITableView()
    
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
        
        // Lottie Animation
//        animationView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        animationView.bottomAnchor.constraint(equalTo: btn.topAnchor).isActive = true
//        animationView.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
//        animationView.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        bindings()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        tableView.reloadData()
        configureNavigationbar()
    }
    
    @objc private func goSettingVC() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    // 불러오기 버튼 이벤트
    @objc private func uploadStudyList() {
        viewModel.uploadData()
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
        let study = viewModel.studyList[indexPath.row]
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
        
        // 완료시 배경색 변경
        if study.isDone == true {
            cell.backgroundColor = .lightGray
//            cell.addSubview(animationView)
//            animationView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
//            animationView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        } else {
            cell.backgroundColor = .white
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
                                     date: date)}
        
        cell.addSubview(animationView)
        animationView.centerXAnchor.constraint(equalTo: cell.centerXAnchor).isActive = true
        animationView.centerYAnchor.constraint(equalTo: cell.centerYAnchor).isActive = true
        viewModel.complete(index: sender.tag)
//        view.addSubview(animationView)
        animationView.play(fromProgress: 0, toProgress: 1, loopMode: .playOnce, completion: {
            (finished) in
            if finished {
                print("finish")
                self.animationView.removeFromSuperview()
            } else {
                print("playing")
            }
        })
        
        
    }
}

