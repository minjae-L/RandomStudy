//
//  AddPopUpViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 4/18/24.
//

import UIKit
protocol AddPopUpViewControllerDelegate: AnyObject {
    func sendedDataFromPopUp()
}

class AddPopUpViewController: UIViewController {
    
//    MARK: UI Property
    private var viewModel = AddViewModel()
    weak var delegate: AddPopUpViewControllerDelegate?
    private var containerView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.clipsToBounds = true
        return view
    }()
    private var messageView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private var lowerStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .horizontal
        stv.alignment = .center
        stv.distribution = .fillEqually
        stv.spacing = 5
        stv.translatesAutoresizingMaskIntoConstraints = false
        return stv
    }()
    
//    private var titleLabel: UILabel = {
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 20)
        lb.text = "추가하기"
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private var errorLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 15)
        lb.textColor = .systemRed
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.text = "빈칸은 추가할 수 없습니다."
        lb.isHidden = true
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.setTitle("추가", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .gray
        btn.addTarget(self, action: #selector(addButtonTapped), for: .touchUpInside)
        btn.isEnabled = false
        return btn
    }()
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemCyan
        btn.setTitle("취소", for: .normal)
        btn.tintColor = .black
        btn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        return btn
    }()
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        tf.addTarget(self, action: #selector(checkBlankTextField(_:)), for: UIControl.Event.editingChanged)
        return tf
    }()
    private func drawUI(_ type: UIType) {
        switch type {
        case .dark:
            self.containerView.backgroundColor = .darkGray
            self.titleLabel.textColor = .white
            self.textField.backgroundColor = .lightGray
            self.textField.attributedPlaceholder = NSAttributedString(string: "  목록을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
            self.textField.textColor = .white
        case .normal:
            self.containerView.backgroundColor = .white
            self.titleLabel.textColor = .black
            self.textField.backgroundColor = .white
            self.textField.attributedPlaceholder = NSAttributedString(string: "  목록을 입력해주세요.", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
            self.textField.textColor = .black
        }
    }
    private func addView() {
        view.addSubview(containerView)
        containerView.addSubview(messageView)
        messageView.addSubview(titleLabel)
        messageView.addSubview(errorLabel)
        messageView.addSubview(textField)
        containerView.addSubview(lowerStackView)
        lowerStackView.addArrangedSubview(cancelButton)
        lowerStackView.addArrangedSubview(addButton)
    }
    
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor, constant: 20),
            containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor, constant:  -20),
            containerView.topAnchor.constraint(greaterThanOrEqualTo: self.view.topAnchor, constant: 30),
            containerView.bottomAnchor.constraint(lessThanOrEqualTo: self.view.bottomAnchor, constant: -30),
            messageView.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 20),
            messageView.heightAnchor.constraint(equalToConstant: 150),
            messageView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            messageView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            titleLabel.topAnchor.constraint(equalTo: messageView.topAnchor, constant: 20),
            titleLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            titleLabel.leadingAnchor.constraint(equalTo: messageView.leadingAnchor),
            titleLabel.trailingAnchor.constraint(equalTo: messageView.trailingAnchor),
            errorLabel.bottomAnchor.constraint(equalTo: textField.topAnchor, constant: -10),
            errorLabel.centerXAnchor.constraint(equalTo: messageView.centerXAnchor),
            textField.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 60),
            textField.leadingAnchor.constraint(equalTo: messageView.leadingAnchor, constant: 20),
            textField.trailingAnchor.constraint(equalTo: messageView.trailingAnchor, constant: -20),
            textField.bottomAnchor.constraint(lessThanOrEqualTo: messageView.bottomAnchor, constant: -10),
            lowerStackView.topAnchor.constraint(equalTo: messageView.bottomAnchor, constant: 20),
            lowerStackView.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 20),
            lowerStackView.trailingAnchor.constraint(equalTo: containerView.trailingAnchor, constant: -20),
            lowerStackView.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -20)
        ])
    }
//    MARK: Method
    @objc func cancelButtonTapped() {
        self.dismiss(animated: true)
    }
    @objc func addButtonTapped() {
        guard let text = self.textField.text else { return }
        if viewModel.isContainsElement(str: text) {
            errorLabel.text = "같은 목록이 존재합니다."
            errorLabel.isHidden = false
        } else {
            errorLabel.isHidden = true
            viewModel.addData(str: text)
            delegate?.sendedDataFromPopUp()
            self.dismiss(animated: true)
        }
        if text == "" {
            errorLabel.text = "공백은 추가할 수 없습니다."
            errorLabel.isHidden = false
        } else {
            if viewModel.isContainsElement(str: text) {
                errorLabel.text = "같은 목록이 존재합니다."
                errorLabel.isHidden = false
            } else {
                errorLabel.isHidden = true
                viewModel.addData(str: text)
                delegate?.sendedDataFromPopUp()
                self.dismiss(animated: true)
            }
        }
        print("delegate: \(delegate)")
    }
    @objc func checkBlankTextField(_ sender: UITextField) {
        if sender.text?.count == 0 {
            self.addButton.isEnabled = false
        } else {
            self.addButton.isEnabled = true
        }
        stateAddButton()
    }
    private func stateAddButton() {
        if self.addButton.isEnabled {
            addButton.backgroundColor = .systemBlue
        } else {
            addButton.backgroundColor = .gray
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        addView()
        configureConstraints()
        drawUI(UIDarkmodeUserDefaults.shared.UIMode)
    }

}
