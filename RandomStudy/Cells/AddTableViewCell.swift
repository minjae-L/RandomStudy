//
//  AddTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/16.
//

import UIKit

class AddTableViewCell: UITableViewCell {
    static let identifier = "AddTableViewCell"
    
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(deleteBtn)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        label.text = nil
    }
    
    public func configure(with model: Study) {
        label.text = model.name
    }
}
