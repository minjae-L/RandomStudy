//
//  AddPopUpViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 4/18/24.
//

import UIKit

class AddPopUpViewController: UIViewController {
    
//    MARK: UI Property
    private var contentView: UIView?
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
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 20)
        lb.text = "추가하기"
        lb.numberOfLines = 0
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    private lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.setTitle("추가", for: .normal)
        btn.tintColor = .white
        btn.backgroundColor = .systemBlue
        return btn
    }()
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemCyan
        btn.setTitle("취소", for: .normal)
        btn.tintColor = .black
        return btn
    }()
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .white
        tf.borderStyle = .roundedRect
        return tf
    }()
    
    private func addView() {
        view.addSubview(containerView)
        containerView.addSubview(messageView)
        messageView.addSubview(titleLabel)
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
    convenience init(contentView: UIView? = nil) {
        self.init()
        self.contentView = contentView
        modalPresentationStyle = .overFullScreen
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .black.withAlphaComponent(0.3)
        addView()
        configureConstraints()
    }

}
