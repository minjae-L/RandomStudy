//
//  SignUpViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 5/11/24.
//

import UIKit

class SignUpViewController: UIViewController {
    private var viewModel = SignUpViewModel()
//    MARK: UI Property
    private let stackView: UIStackView = {
        let sv = UIStackView()
        sv.axis = .vertical
        sv.spacing = 10
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.distribution = .equalSpacing
        
        return sv
    }()
    private let signUpLabel: UILabel = {
        let lb = UILabel()
        lb.text = "회원가입"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: 20)
        
        return lb
    }()
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "이메일을 입력해주세요."
        tf.translatesAutoresizingMaskIntoConstraints = false
        
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호를 입력해주세요."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        
        return tf
    }()
    private let confirmPasswordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "비밀번호를 한번 더 입력해주세요."
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.isSecureTextEntry = true
        
        return tf
    }()
    private let confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("계정 생성", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    
//    MARK: Method
    // UI Property 등록
    private func addViews() {
        view.addSubview(stackView)
        view.addSubview(signUpLabel)
        stackView.addArrangedSubview(emailTextField)
        stackView.addArrangedSubview(passwordTextField)
        stackView.addArrangedSubview(confirmPasswordTextField)
        stackView.addArrangedSubview(confirmButton)
        
    }
    // 레이아웃 설정
    private func configureLayout() {
        NSLayoutConstraint.activate([
            signUpLabel.topAnchor.constraint(equalTo: view.topAnchor, constant: 50),
            signUpLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            signUpLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
            confirmButton.heightAnchor.constraint(equalToConstant: 50),
            confirmPasswordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    // UI Property 색 설정
    private func configureColor() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        signUpLabel.textColor = UIColor(named: "LabelTextColor")
        stackView.backgroundColor = UIColor(named: "ViewBackgroundColor")
        emailTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        emailTextField.textColor = UIColor(named: "TextFieldTextColor")
        passwordTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        passwordTextField.textColor = UIColor(named: "TextFieldTextColor")
        confirmPasswordTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        confirmPasswordTextField.textColor = UIColor(named: "TextFieldTextColor")
        confirmButton.backgroundColor = .systemBlue
        confirmButton.setTitleColor(.white, for: .normal)
    }
//    MARK: Button Action
    @objc func confirmButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text,
              let confirmPassword = confirmPasswordTextField.text
        else { return }
        
        self.showSpinner{
            self.hideSpinner{
                self.viewModel.signUp(email: email, password: password, confirmPassword: confirmPassword) { [weak self] isCreated, result in
                    isCreated ? self?.dismiss(animated: true) : self?.showMessageAlert(result)
                }
            }
        }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureLayout()
        configureColor()
        emailTextField.delegate = self
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
    }
    // 키보드 화면에 따른 뷰 조정
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    // 키보드의 크기를 구하고, 크기에 따라서 뷰 조정
    @objc func keyboardUp(notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            
            UIView.animate(withDuration: 0.3, animations: {
                self.view.transform = CGAffineTransform(translationX: 0, y: -keyboardRectangle.height/2)
            })
        }
    }
    @objc func keyboardDown() {
        self.view.transform = .identity
    }
}

// MARK: TextField Delegate
extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}



