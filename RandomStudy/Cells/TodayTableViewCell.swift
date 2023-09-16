//
//  TodayTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/15.
//

import UIKit

class TodayTableViewCell: UITableViewCell {
    static let identifier = "TodayTableViewCell"
    
    let label: UILabel = {
        let lbl = UILabel()
        lbl.numberOfLines = 1
        
        return lbl
    }()
    
    let deleteBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "trash"), for: .normal)
        btn.tintColor = .systemBlue
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        
        return btn
    }()

    let checkBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        btn.tintColor = .systemBlue
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        
        return btn
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(deleteBtn)
        contentView.addSubview(checkBtn)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height
        label.frame = CGRect(x: 20,
                             y: 0,
                             width: contentView.frame.size.width - 20 - checkBtn.frame.width * 2 - 25,
                             height: contentView.frame.size.height)
        
        checkBtn.frame = CGRect(x: contentView.frame.width - 10 - size/3,
                                y: size/3,
                                width: size/3,
                                height: size/3)
        deleteBtn.frame = CGRect(x: contentView.frame.width - 10 - size/3 - checkBtn.frame.size.width - 15,
                                 y: size/3,
                                 width: size/3,
                                 height: size/3)
    }
    
    override func prepareForReuse() {
        label.text = nil
    }
    
    public func configure(with model: Study) {
        label.text = model.name
    }

}
