//
//  LoginViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 5/11/24.
//

import UIKit

class LoginViewController: UIViewController {
    private let viewModel = LoginViewModel()
//    MARK: UI Property
    private let loginLabel: UILabel = {
        let lb = UILabel()
        lb.text = "로그인"
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center
        lb.font = .boldSystemFont(ofSize: 30)
        
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
    private let emailTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "E-mail"
        
        return tf
    }()
    private let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        
        return tf
    }()
    private let loginButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("로그인", for: .normal)
        btn.addTarget(self, action: #selector(logInButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    private let findLoginInfoButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("이메일/비밀번호 찾기", for: .normal)
        btn.isEnabled = false
        
        return btn
    }()
    private let signUpButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("회원가입", for: .normal)
        btn.addTarget(self, action: #selector(signUpButtonTapped), for: .touchUpInside)
        
        return btn
    }()
//    MARK: Methods
    // UI Property 등록
    private func addViews() {
        view.addSubview(stackView)
        stackView.addArrangedSubview(loginLabel)
        stackView.addArrangedSubview(textFieldStackView)
        stackView.addArrangedSubview(buttonStackView)
        textFieldStackView.addArrangedSubview(emailTextField)
        textFieldStackView.addArrangedSubview(passwordTextField)
        buttonStackView.addArrangedSubview(loginButton)
        buttonStackView.addArrangedSubview(findLoginInfoButton)
        buttonStackView.addArrangedSubview(signUpButton)
    }
    // UI Property 색 설정
    private func configureColor() {
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        loginLabel.textColor = UIColor(named: "LabelTextColor")
        emailTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        emailTextField.textColor = UIColor(named: "TextFieldTextColor")
        passwordTextField.backgroundColor = UIColor(named: "CellBackgroundColor")
        passwordTextField.textColor = UIColor(named: "TextFieldTextColor")
        loginButton.setTitleColor(UIColor.white, for: .normal)
        loginButton.backgroundColor = .systemBlue
        findLoginInfoButton.setTitleColor(UIColor.white, for: .normal)
        findLoginInfoButton.backgroundColor = .systemGray
        signUpButton.setTitleColor(UIColor.white, for: .normal)
        signUpButton.backgroundColor = .systemBlue
        stackView.backgroundColor = UIColor(named: "ViewBackgroundColor")
    }
    // 레이아웃 설정
    private func configureLayout() {
        NSLayoutConstraint.activate([
            stackView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            emailTextField.heightAnchor.constraint(equalToConstant: 50),
            passwordTextField.heightAnchor.constraint(equalToConstant: 50),
        ])
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addViews()
        configureColor()
        configureLayout()
        emailTextField.delegate = self
        passwordTextField.delegate = self
    }
    
    // 키보드에 맞춰서 UI크기 조정
    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardUp), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardDown), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    // 빈화면 클릭시 키보드 내리기
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
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
//    MARK: Button Actions
    // 회원가입 뷰로 이동
    @objc func signUpButtonTapped() {
        let vc = SignUpViewController()
        self.present(vc, animated: true)
    }
    // 로그인
    @objc func logInButtonTapped() {
        guard let email = emailTextField.text,
              let password = passwordTextField.text
        else { return }
        
        self.showSpinner{
            self.viewModel.login(email: email, password: password) { [weak self] result, errorMessage in
                guard let self = self else { return }
                if result {
                    let navigationController = UINavigationController(rootViewController: TodayViewController())
                    navigationController.modalPresentationStyle = .fullScreen
                    self.present(navigationController, animated: true)
                    self.viewModel.makeFirebaseDocument()
                } else {
                    self.showMessageAlert(errorMessage)
                }
                
            }
            self.hideSpinner{}
        }
    }
}

// MARK: TextField Delegate
extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
