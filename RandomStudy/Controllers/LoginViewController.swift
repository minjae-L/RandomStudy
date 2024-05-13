//
//  LoginViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 5/11/24.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
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
        print("current account: \(Auth.auth().currentUser)")
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
        // 예외처리 1
        if email.isEmpty || password.isEmpty {
            self.showMessageAlert("이메일 또는 비밀번호를 입력해주세요.")
            return
        }
        // 로딩화면 보여주고, 로딩화면 지우면서 로그인 과정 실행
        showSpinner {
            Auth.auth().signIn(withEmail: email, password: password) {[weak self] authResult, error in
                guard let self = self else { return }
                self.hideSpinner {
                    // 예외처리 2
                    if let error = error {
                        let authError = error as NSError
                        if let ac = AuthErrorCode.Code(rawValue: authError.code) {
                            switch ac {
                            case .wrongPassword:
                                self.showMessageAlert("비밀번호가 일치하지 않습니다.")
                            case .invalidEmail:
                                self.showMessageAlert("이메일 형식이 올바르지 않습니다.")
                            case .userDisabled:
                                self.showMessageAlert("이 계정은 현재 사용중지 상태입니다.")
                            case .operationNotAllowed:
                                self.showMessageAlert("현재 이메일 로그인을 지원하지 않습니다.")
                            default:
                                self.showMessageAlert("로그인 실패\n이메일과 비밀번호를 확인해주세요.")
                            }
                        }
                    } else {
                        // 로그인 성공하면 TodayVC로 이동
                        let vc = TodayViewController()
                        let navigationController = UINavigationController(rootViewController: vc)
                        navigationController.modalPresentationStyle = .fullScreen
                        self.present(navigationController, animated: true)
                        print("login success")
                    }
                }
            }
        }
    }
}
