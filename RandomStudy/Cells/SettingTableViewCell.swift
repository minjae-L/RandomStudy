//
//  SettingTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/14.
//

import UIKit

class SettingTableViewCell: UITableViewCell {
    static let identifier = "SettingTableViewCell"
    private let iconContainer: UIView = {
        let view = UIView()
        view.clipsToBounds = true
        view.layer.cornerRadius = 8
        view.layer.masksToBounds = true
        
        return view
    }()
    
    private let iconImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.tintColor = .white
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let label: UILabel = {
        let label = UILabel()
        label.numberOfLines = 1
        
        return label
    }()
    
    // 생성 함수 여기서 이미지뷰와 라벨을 커스텀뷰에 넣는다.
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        iconContainer.addSubview(iconImageView)
        contentView.clipsToBounds = true
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let size: CGFloat = contentView.frame.size.height - 12
        iconContainer.frame = CGRect(x: 15, y: 6, width: size, height: size)
        
        let imageSize: CGFloat = size/1.5
        iconImageView.frame = CGRect(x: (size-imageSize)/2, y: (size-imageSize)/2, width: imageSize, height: imageSize)
        
        label.frame = CGRect(
            x: 25 + iconContainer.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 2 * (25 + iconContainer.frame.size.width),
            height: contentView.frame.size.height
        )
    }
    
    // 셀이 재사용 될때 한번 초기화해주는 코드
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
    }
    func setUIColor() {
        self.backgroundColor = UIColor(named: "CellBackgroundColor")
        self.contentView.backgroundColor = UIColor(named: "CellBackgroundColor")
        self.label.textColor = UIColor(named: "LabelTextColor")
    }
    func logOutCellConfigure() {
        label.textColor = .systemRed
        self.backgroundColor = .clear
        self.contentView.backgroundColor = .clear
        label.textAlignment = .center
    }
    // 셀에 있는 이미지뷰와 라벨을 미리 정했던 구조체와 연결
    func configure(with model: SettingsOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        self.accessoryType = model.accessoryType
        if label.text == "로그아웃" {
            logOutCellConfigure()
        }
    }
}
