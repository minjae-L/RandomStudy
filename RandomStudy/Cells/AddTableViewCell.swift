//
//  AddTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/16.
//

import UIKit

class AddTableViewCell: UITableViewCell {
    static let identifier = "AddTableViewCell"
    
    let cellView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white

        return view
    }()
    
    let label: UILabel = {
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
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(cellView)
        cellView.addSubview(label)
        cellView.addSubview(deleteBtn)
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size = contentView.frame.size.height
        cellView.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        cellView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        cellView.rightAnchor.constraint(equalTo: contentView.rightAnchor).isActive = true
        cellView.leftAnchor.constraint(equalTo: contentView.leftAnchor).isActive = true
        
        label.topAnchor.constraint(equalTo: cellView.topAnchor, constant: 10).isActive = true
        label.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -10).isActive = true
        label.leadingAnchor.constraint(equalTo: cellView.leadingAnchor, constant: 20).isActive = true
        label.trailingAnchor.constraint(equalTo: cellView.trailingAnchor, constant: -60).isActive = true
        
        deleteBtn.centerYAnchor.constraint(equalTo: cellView.centerYAnchor).isActive = true
        deleteBtn.rightAnchor.constraint(equalTo: cellView.rightAnchor,constant: -10).isActive = true
        deleteBtn.leftAnchor.constraint(equalTo: label.rightAnchor, constant: size/3).isActive = true
        deleteBtn.topAnchor.constraint(equalTo: cellView.topAnchor, constant: size/3).isActive = true
        deleteBtn.bottomAnchor.constraint(equalTo: cellView.bottomAnchor, constant: -(size/3)).isActive = true
    }
    
    override func prepareForReuse() {
        label.text = nil
    }
    
    public func configure(with model: Study) {
        label.text = model.name
    }
}
