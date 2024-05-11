//
//  SignUpViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 5/11/24.
//

import UIKit
import FirebaseAuth

class SignUpViewController: UIViewController {
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        
        return sv
    }()
    private let idTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "아이디를 입력해주세요."
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호를 입력해주세요."
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    private let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호를 한번 더 입력해주세요."
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    private let confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("계정 생성", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private func addViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(idTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        
        configureLayout()
        configureColor()
    }
    private func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 100),
            stackView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -50),
        ])
    }
    private func configureColor() {
        stackView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        idTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        idTextField.textColor = UIColor(named: "TextFieldTextColor")
        passwordTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        passwordTextField.textColor = UIColor(named: "TextFieldTextColor")
        confirmPasswordTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        confirmPasswordTextField.textColor = UIColor(named: "TextFieldTextColor")
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        // Do any additional setup after loading the view.
    }
}
