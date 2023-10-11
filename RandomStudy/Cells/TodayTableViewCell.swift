//
//  TodayTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/15.
//

import UIKit

class TodayTableViewCell: UITableViewCell {
    static let identifier = "TodayTableViewCell"
    
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

    let checkBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        btn.tintColor = .systemBlue
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    private func setLayout() {
        let size: CGFloat = contentView.frame.size.height
        
        checkBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -10).isActive = true
        checkBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        checkBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
        checkBtn.widthAnchor.constraint(equalToConstant: size/2).isActive = true
        
        deleteBtn.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 25).isActive = true
        deleteBtn.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -25).isActive = true
        deleteBtn.rightAnchor.constraint(equalTo: checkBtn.leftAnchor, constant: -10).isActive = true
        deleteBtn.widthAnchor.constraint(equalToConstant: size/2).isActive = true
        
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: deleteBtn.leadingAnchor).isActive = true
        
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(deleteBtn)
        contentView.addSubview(checkBtn)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        label.text = nil
    }
    
    public func configure(with model: TodayStudyList) {
        label.text = model.name
    }

}
