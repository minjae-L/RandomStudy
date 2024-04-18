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
        return view
    }()
    private var upperStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .vertical
        stv.alignment = .top
        stv.spacing = 5
        stv.distribution = .fillEqually
        stv.translatesAutoresizingMaskIntoConstraints = false
        stv.backgroundColor = .green
        return stv
    }()
    private var lowerStackView: UIStackView = {
        let stv = UIStackView()
        stv.axis = .horizontal
        stv.alignment = .center
        stv.distribution = .fillEqually
        stv.spacing = 5
        stv.translatesAutoresizingMaskIntoConstraints = false
        stv.backgroundColor = .blue
        return stv
    }()
    private lazy var titleLabel: UILabel = {
        let lb = UILabel()
        lb.font = .boldSystemFont(ofSize: 20)
        lb.text = "TEST"
        lb.numberOfLines = 0
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.backgroundColor = .brown
        return lb
    }()
    private lazy var addButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.titleLabel?.text = "추가하기"
        btn.tintColor = .white
        return btn
    }()
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemCyan
        btn.titleLabel?.text = "취소"
        btn.tintColor = .black
        return btn
    }()
    private lazy var textField: UITextField = {
        let tf = UITextField()
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = .orange
        return tf
    }()
    
    private func addView() {
        view.addSubview(containerView)
//        containerView.addArrangedSubview(upperStackView)
//        containerView.addArrangedSubview(lowerStackView)
//        containerView.addSubview(upperStackView)
//        containerView.addSubview(lowerStackView)
//        upperStackView.addArrangedSubview(titleLabel)
//        upperStackView.addArrangedSubview(textField)
//        lowerStackView.addArrangedSubview(cancelButton)
//        lowerStackView.addArrangedSubview(addButton)
    }
    private func configureConstraints() {
        NSLayoutConstraint.activate([
            containerView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            containerView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            containerView.leftAnchor.constraint(equalTo: self.view.leftAnchor),
            containerView.rightAnchor.constraint(equalTo: self.view.rightAnchor),
            containerView.topAnchor.constraint(equalTo: self.view.topAnchor),
            containerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            
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
