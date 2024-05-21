//
//  DataMigrationViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 5/18/24.
//

import UIKit

class DataMigrationViewController: UIViewController {
    private let contentStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .vertical
        view.spacing = 20
        view.alignment = .fill
        view.distribution = .fillEqually
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return view
    }()
    private let buttonStackView: UIStackView = {
        let view = UIStackView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.axis = .horizontal
        view.spacing = 30
        view.distribution = .fillEqually
        view.isLayoutMarginsRelativeArrangement = true
        view.layoutMargins = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        return view
    }()
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 40)
        lb.text = "환영합니다!"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center
        return lb
    }()
    private let descriptionLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "이전에 사용했던 데이터가 존재합니다.\n데이터를 연동하시겠습니까?"
        lb.textAlignment = .center
        lb.numberOfLines = 0
        
        return lb
    }()
    private let warningLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15)
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.text = "(데이터 연동시 저장되었던 이전 데이터는 사라지게 됩니다.)\n\n"
        lb.textAlignment = .center
        lb.textColor = .systemRed
        
        return lb
    }()
    private let confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("연동하기", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        
        return btn
    }()
    private let cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("삭제하기", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemRed
        return btn
    }()
    private func addView() {
        contentStackView.addArrangedSubview(titleLabel)
        contentStackView.addArrangedSubview(descriptionLabel)
        contentStackView.addArrangedSubview(warningLabel)
        contentStackView.addArrangedSubview(buttonStackView)
        buttonStackView.addArrangedSubview(cancelButton)
        buttonStackView.addArrangedSubview(confirmButton)
        view.addSubview(contentStackView)
    }
    private func configureLayout() {
        NSLayoutConstraint.activate([
            contentStackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            contentStackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            contentStackView.topAnchor.constraint(greaterThanOrEqualTo: view.topAnchor, constant: 20),
            contentStackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            contentStackView.leadingAnchor.constraint(greaterThanOrEqualTo: view.leadingAnchor, constant: 10),
            contentStackView.trailingAnchor.constraint(lessThanOrEqualTo: view.trailingAnchor, constant: -10),
        ])
    }
    private func configureColor() {
        view.backgroundColor = .black.withAlphaComponent(0.3)
        contentStackView.backgroundColor = UIColor(named: "ViewBackgroundColor")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        configureLayout()
        configureColor()
    }

}
