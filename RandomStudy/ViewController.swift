//
//  ViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/06/05.
//

import UIKit


class ViewController: UIViewController {
    private var todayStudy = [Study]() {
        didSet {
            tableView.reloadData()
        }
    }
    private var cellData = StudyServer.dataArray {
        didSet {
            StudyServer.dataArray = cellData
            print("didSet \(StudyServer.dataArray)")
            tableView.reloadData()
        }
    }
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
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        cellData = StudyServer.getData()
    }
    
    @objc private func goSettingVC() {
        let vc = SettingViewController()
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
    @objc private func uploadStudyList() {
        let studyServer = StudyServer.dataArray
        if studyServer.isEmpty {
            print("Empty")
        } else {
            if isEqualArray(toadyList: todayStudy, studyData: studyServer) {
                print("모든 목록 불러오기 완료")
            } else {
                var num = Int.random(in: 0..<studyServer.count)
                var random = studyServer[num]
                
                while todayStudy.filter{ $0.name == random.name}.count > 0 {
                    num = Int.random(in: 0..<studyServer.count)
                    random = studyServer[num]
                }
                todayStudy.append(random)
                print("불러오기 완료\(random)")
                print(studyServer)
                print(todayStudy)
            }
        }
    }
    
    private func isEqualArray(toadyList: [Study], studyData: [Study]) -> Bool {
        var result = 0
        for i in 0..<toadyList.count {
            for j in 0..<studyData.count {
                if toadyList[i].name == studyData[j].name {
                    result += 1
                    break
                }
            }
        }
        if result == studyData.count {
            return true
        } else {
            return false
        }
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
        return todayStudy.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let study = todayStudy[indexPath.row]
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: TodayTableViewCell.identifier,
            for: indexPath
        ) as? TodayTableViewCell else {
            return UITableViewCell()
        }
        cell.configure(with: study)
        cell.deleteBtn.tag = indexPath.row
        cell.deleteBtn.addTarget(self, action: #selector(deleteBtnTapped(sender:)), for: .touchUpInside)
        cell.checkBtn.addTarget(self, action: #selector(checkBtnTapped(sender:)), for: .touchUpInside)
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    @objc func deleteBtnTapped(sender: UIButton) {
//        print("Tapped deleteBtn")
        todayStudy.remove(at: sender.tag)
        
    }
    @objc func checkBtnTapped(sender: UIButton) {
//        print("Tapped checkBtn")
//        cellData.remove(at: index)
//        tableView.reloadData()
    }
}

