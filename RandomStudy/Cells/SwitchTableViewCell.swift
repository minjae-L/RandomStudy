//
//  SwitchTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/14.
//

import UIKit
protocol SwitchTableViewCellDelegate: AnyObject {
    func changedViewMode()
}
class SwitchTableViewCell: UITableViewCell {
    static let identifier = "SwitchTableViewCell"
    weak var delegate: SwitchTableViewCellDelegate?
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
    
    let mySwitch: UISwitch = {
        let mySwitch = UISwitch()
        mySwitch.onTintColor = .systemBlue
        mySwitch.addTarget(self, action: #selector(clickSwitch), for: .valueChanged)
        return mySwitch
    }()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(label)
        contentView.addSubview(iconContainer)
        contentView.addSubview(mySwitch)
        iconContainer.addSubview(iconImageView)
        
        contentView.clipsToBounds = true
        accessoryType = .none
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
        
        mySwitch.sizeToFit()
        mySwitch.frame = CGRect(
            x: contentView.frame.size.width - mySwitch.frame.size.width - 20,
            y: (contentView.frame.size.height - mySwitch.frame.size.height)/2,
            width: mySwitch.frame.size.width,
            height: mySwitch.frame.size.height)
        
        label.frame = CGRect(
            x: 25 + iconContainer.frame.size.width,
            y: 0,
            width: contentView.frame.size.width - 15 - iconContainer.frame.size.width,
            height: contentView.frame.size.height
        )
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        iconImageView.image = nil
        label.text = nil
        iconContainer.backgroundColor = nil
        mySwitch.isOn = false
    }
    @objc func clickSwitch() {
        UIDarkmodeUserDefaults.shared.changeMode()
        delegate?.changedViewMode()
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
    func configure(with model: SettingSwitchOption) {
        label.text = model.title
        iconImageView.image = model.icon
        iconContainer.backgroundColor = model.iconBackgroundColor
        mySwitch.setOn(UIDarkmodeUserDefaults.shared.isDark, animated: true)
        mySwitch.isOn = model.isOn
    }
}
