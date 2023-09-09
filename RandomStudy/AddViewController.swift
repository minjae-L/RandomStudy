//
//  AddViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/04.
//

import UIKit


// Study data
struct Study {
    let name: String?
}

class StudyServer {
    static var dataArray = [Study]()
    
    static func getData() -> [Study] {
        if dataArray.isEmpty {
            return [Study(name: "비어있습니다.")]
        } else {
            return dataArray
        }
    }
    static func addData(str: String?) {
        guard let data = str else {
            return print("Optional")
        }
        dataArray.append(Study(name: data))
    }
}



class AddViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private var study = StudyServer.getData()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return study.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "studyCell", for: indexPath)
        cell.textLabel?.text = study[indexPath.row].name
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func updateData() {
        tbView.reloadData()
    }
    
    var tbView = UITableView()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // NavigationBar
        self.view.backgroundColor = .white
        self.navigationItem.title = "add"
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.backgroundColor = .white
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(systemName: "pencil"), style: .plain, target: self, action: #selector(addCategory))
        
        // TableView
        tbView = UITableView()
        view.addSubview(tbView)
        //        tbView.backgroundColor = .green
        tbView.separatorStyle = .none
        tbView.translatesAutoresizingMaskIntoConstraints = false
        tbView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        tbView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        tbView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        tbView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        tbView.dataSource = self
        tbView.delegate = self
        tbView.register(UITableViewCell.self, forCellReuseIdentifier: "studyCell")
        
        
    }
    
    @objc func addCategory() {
        let alert = UIAlertController(title: "추가하기", message: "", preferredStyle: .alert)
        
        let yes = UIAlertAction(title: "OK", style: .default) { (yes) in
            let str = alert.textFields?[0].text
            StudyServer.addData(str: str)
            print("add \(str)")
            print(StudyServer.getData())
            self.study = StudyServer.getData()
            self.updateData()
        }
        
        let cancel = UIAlertAction(title: "NO", style: .cancel)
        
        alert.addTextField()
        alert.addAction(yes)
        alert.addAction(cancel)
        self.present(alert, animated: true, completion: nil)
    }
    
}


