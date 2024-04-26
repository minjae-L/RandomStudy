//
//  AddTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/16.
//

import UIKit

protocol AddViewControllerButtonDelegate: AnyObject {
    func cellDeleteButtonTapped(name: String)
}

class AddTableViewCell: UITableViewCell {
    static let identifier = "AddTableViewCell"
    weak var delegate: AddViewControllerButtonDelegate?
    var indexPathStudyName: String = ""
    
    @objc func deleteButtonTapped() {
        delegate?.cellDeleteButtonTapped(name: indexPathStudyName)
    }
    
    private let label: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        lbl.translatesAutoresizingMaskIntoConstraints = false
        
        return lbl
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.tintColor = .systemBlue
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private func setLayout() {
        label.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -10).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -60).isActive = true
        
        deleteBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        deleteBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor,constant: -10).isActive = true
        deleteBtn.leftAnchor.constraint(equalTo: label.rightAnchor, constant: 25).isActive = true
        deleteBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        deleteBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
    }
    
    private func setupButtonEvent() {
        deleteBtn.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(deleteBtn)
        setLayout()
        setupButtonEvent()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        label.text = nil
    }
    func setUIColor(_ mode: UIType) {
        switch mode {
        case .dark:
            self.backgroundColor = .clear
            self.backgroundView?.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            self.contentView.backgroundColor = UIColor.gray.withAlphaComponent(0.2)
            self.label.textColor = .white
        case .normal:
            self.backgroundView?.backgroundColor = UIColor.white.withAlphaComponent(1)
            self.contentView.backgroundColor = UIColor.white.withAlphaComponent(1)
            self.label.textColor = .black
        }
    }
    func configure(with model: StudyModel) {
        label.text = model.name
        if let name = model.name {
            indexPathStudyName = name
        }
    }
}

