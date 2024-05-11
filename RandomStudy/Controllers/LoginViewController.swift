//
//  LoginViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 5/11/24.
//

import UIKit

class LoginViewController: UIViewController {
//    MARK: UI Property
    private let loginLabel: UILabel = {
        let lb = UILabel()
        lb.text = "로그인"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center
        
        return lb
    }()
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 80
        sv.distribution = .equalSpacing
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins.top = 50
        sv.layoutMargins.left = 10
        sv.layoutMargins.right = 10
        sv.layoutMargins.bottom = 50
        
        return sv
    }()
    private let textFieldStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 5
        sv.distribution = .fill
        sv.isLayoutMarginsRelativeArrangement = true
        sv.layoutMargins.top = 5
        sv.layoutMargins.bottom = 5
        
        return sv
    }()
    private let buttonStackView: UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.axis = .vertical
        sv.spacing = 10
        
        return sv
    }()
    private let idTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "ID"
        
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        
        return tf
    }()
    private let loginButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("로그인", for: .normal)
        
        return btn
    }()
    private let findLoginInfoButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("아이디/비밀번호 찾기", for: .normal)
        
        return btn
    }()
    private let signUpButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("회원가입", for: .normal)
        
        return btn
    }()
    private func addViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(loginLabel)
        stackView.addArrangedSubview(textFieldStackView)
        stackView.addArrangedSubview(buttonStackView)
        textFieldStackView.addArrangedSubview(idTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        buttonStackView.addArrangedSubview(loginButton)
        buttonStackView.addArrangedSubview(findLoginInfoButton)
        buttonStackView.addArrangedSubview(signUpButton)
        configureColor()
        configureLayout()
    }
    private func configureColor() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        loginLabel.textColor = UIColor(named: "LabelTextColor")
        idTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        idTextField.textColor = UIColor(named: "TextFieldTextColor")
        passwordTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        passwordTextField.textColor = UIColor(named: "TextFieldTextColor")
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        findLoginInfoButton.setTitleColor(UIColor.white, for: .normal)
        findLoginInfoButton.backgroundColor = .systemBlue
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.backgroundColor = .systemBlue
        stackView.backgroundColor = UIColor(named: "ViewBackgroundColor")
    }
    private func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
//            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
//            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
//            stackView.topAnchor.constraint(equalTo: view.topAnchor, constant: 20),
//            stackView.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -20),
            idTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
    }

}
