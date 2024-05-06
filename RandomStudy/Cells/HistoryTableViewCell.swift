//
//  HistoryCellTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/10/15.
//

import UIKit

class HistoryTableViewCell: UITableViewCell {
    static let identifier = "HistoryTableViewCell"
    
    private let label: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .left
        lb.numberOfLines = 1
        
        return lb
    }()
    
    private func setLayout() {
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant:  20).isActive = true
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        setLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func setUIColor() {
        
        self.backgroundColor = .clear
        self.contentView.backgroundColor = UIColor(named: "CellBackgroundColor")
        self.label.textColor = UIColor(named: "LabelTextColor")
    }
    override func prepareForReuse() {
        label.text = nil
    }
    
    func configure(with model: StudyModel) {
        label.text = model.name
    }
}
