//
//  DarkModeSettingCollectionViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 5/6/24.
//

import UIKit

class DarkModeSettingCollectionViewCell: UICollectionViewCell {
    static let identifier = "DarkModeSettingCollectionViewCell"
    private let titleLabel: UILabel = {
        let lb = UILabel()
        lb.numberOfLines = 0
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .left
        lb.text = "TEST"
        lb.textColor = UIColor(named: "LabelTextColor")
        return lb
    }()
    
    private let button: UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private func addViews() {
        contentView.addSubview(titleLabel)
        contentView.addSubview(button)
    }
    private func setLayout() {
        NSLayoutConstraint.activate([
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            button.leftAnchor.constraint(equalTo: titleLabel.rightAnchor, constant: 50),
            button.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -30),
            button.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            button.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    override init(frame: CGRect) {
        super.init(frame: .zero)
        addViews()
        setLayout()
    }
    
    func configure(_ model: ModeOptions) {
        self.titleLabel.text = model.title
        let value = UIModeUserDefaults.shared.modeValue
        if model.mode == value {
            self.button.setImage(UIImage(systemName: "circle.circle.fill"), for: .normal)
        } else {
            self.button.setImage(UIImage(systemName: "circle.circle"), for: .normal)

        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
