//
//  ViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/06/05.
//

import UIKit

class ViewController: UIViewController {
    
    let test = UILabel()
    let button = UIButton()
    let toolbar = UIToolbar()
    lazy var toolbarItem1: UIBarButtonItem = {
        let item = UIBarButtonItem(barButtonSystemItem: .refresh, target: self, action: nil)
        return item
    }()
    var items: [UIBarButtonItem] = []
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(test)
        view.addSubview(toolbar)
        
        test.text = "text"
        test.translatesAutoresizingMaskIntoConstraints = false
        test.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        test.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        
        self.navigationItem.title = "Main"
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "+", style: .plain, target: self, action: #selector(presentAddVC))
        items.append(toolbarItem1)
        
        toolbar.translatesAutoresizingMaskIntoConstraints = false
        toolbar.leadingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.leadingAnchor, multiplier: 0).isActive = true
        toolbar.bottomAnchor.constraint(equalToSystemSpacingBelow: view.safeAreaLayoutGuide.bottomAnchor, multiplier: 0).isActive = true
        toolbar.trailingAnchor.constraint(equalToSystemSpacingAfter: view.safeAreaLayoutGuide.trailingAnchor, multiplier: 0).isActive = true
        toolbar.setItems([toolbarItem1], animated: true)
        
        button.setTitle("Show", for: .normal)
        view.addSubview(button)
        button.backgroundColor = .systemBlue
        button.frame = CGRect(x: 100, y: 100, width: 200, height: 50)
        button.addTarget(self, action: #selector(didTapButton), for: .touchUpInside)
    }

    @objc private func didTapButton() {

    }
    
    @objc private func presentAddVC() {
//        let vc = AddCategoryViewController()
//
//        let navVC = UINavigationController(rootViewController: vc)
//        navVC.modalPresentationStyle = .fullScreen
//
//        present(navVC, animated: true)
    }

}
