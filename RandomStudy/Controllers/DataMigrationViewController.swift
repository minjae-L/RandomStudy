//
//  DataMigrationViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 5/18/24.
//

import UIKit

// 데이터 연동시 정보 전달을 위한 델리게이트
protocol DataMigrationViewControllerDelegate: AnyObject {
    func didTappedInitialData()
}

class DataMigrationViewController: UIViewController {
    private let viewModel = DataMigrationViewModel()
    weak var delegate: DataMigrationViewControllerDelegate?
//    MARK: UI Property
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
    private lazy var confirmButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("연동하기", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemBlue
        btn.addTarget(self, action: #selector(confirmButtonTapped), for: .touchUpInside)
        
        return btn
    }()
    private lazy var cancelButton: UIButton = {
        let btn = UIButton()
        btn.setTitle("삭제하기", for: .normal)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = .systemRed
        btn.addTarget(self, action: #selector(cancelButtonTapped), for: .touchUpInside)
        
        return btn
    }()
//    MARK: Method
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
    // 연동하기 버튼 액션
    @objc func confirmButtonTapped() {
        print("DataMigrationVC:: confirmButtonTapped:: Excuted")
        showSpinner{
            self.hideSpinner {
                // 데이터 마이그레이션 진행하고, 값이 변경됬다는것을 델리게이트를 통해서 todayVC에게 알림
                self.viewModel.dataMigration()
                self.delegate?.didTappedInitialData()
                self.dismiss(animated: true)
            }
        }
    }
    // 삭제하기 버튼 액션
    @objc func cancelButtonTapped() {
        // 내부데이터 제거
        DBHelper.shared.resetAllTable()
        self.dismiss(animated: true)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        addView()
        configureLayout()
        configureColor()
    }

}
