//
//  TodayTableViewCell.swift
//  RandomStudy
//
//  Created by 이민재 on 2023/09/15.
//

import UIKit
import Lottie

protocol TodayTableViewCellDelegate: AnyObject {
    func checkButtonTapped(name: String)
    func deleteButtonTapped(name: String)
}

class TodayTableViewCell: UITableViewCell {
    static let identifier = "TodayTableViewCell"
    weak var delegate: TodayTableViewCellDelegate?
    
    var name: String = ""
    // 체크버튼
    @objc func checkButtonTapped() {
        delegate?.checkButtonTapped(name: self.name)
        checkView.play()
    }
    // 삭제버튼
    @objc func deleteButtonTapped() {
        delegate?.deleteButtonTapped(name: name)
    }
    
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

    let checkBtn: UIButton = {
        let btn = UIButton()
        btn.setImage(UIImage(systemName: "checkmark.circle"), for: .normal)
        btn.tintColor = .systemBlue
        btn.contentVerticalAlignment = .fill
        btn.contentHorizontalAlignment = .fill
        btn.translatesAutoresizingMaskIntoConstraints = false
        
        return btn
    }()
    
    let checkView: LottieAnimationView = {
        let view = LottieAnimationView(name: "check")
        view.translatesAutoresizingMaskIntoConstraints = false
        view.widthAnchor.constraint(equalToConstant: 80).isActive = true
        view.heightAnchor.constraint(equalToConstant: 80).isActive = true
        return view
    }()
    private func setupButtonEvent() {
        checkBtn.addTarget(self, action: #selector(checkButtonTapped), for: .touchUpInside)
        deleteBtn.addTarget(self, action: #selector(deleteButtonTapped), for: .touchUpInside)
    }
    
    private func setLayout() {
        let size: CGFloat = contentView.frame.size.height
        
        checkBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        checkBtn.rightAnchor.constraint(equalTo: contentView.rightAnchor, constant: -16).isActive = true
        checkBtn.widthAnchor.constraint(equalToConstant: size / 3 * 2).isActive = true
        checkBtn.heightAnchor.constraint(equalToConstant: size / 3 * 2).isActive = true
        
        deleteBtn.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        deleteBtn.rightAnchor.constraint(equalTo: checkBtn.leftAnchor, constant: -16).isActive = true
        deleteBtn.widthAnchor.constraint(equalToConstant: size / 3 * 2).isActive = true
        deleteBtn.heightAnchor.constraint(equalToConstant: size / 3 * 2).isActive = true
        
        label.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20).isActive = true
        label.bottomAnchor.constraint(equalTo: contentView.bottomAnchor).isActive = true
        label.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        label.trailingAnchor.constraint(equalTo: deleteBtn.leadingAnchor).isActive = true
        checkView.centerXAnchor.constraint(equalTo: contentView.centerXAnchor).isActive = true
        checkView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        selectionStyle = .none
        contentView.addSubview(label)
        contentView.addSubview(deleteBtn)
        contentView.addSubview(checkBtn)
        contentView.addSubview(checkView)
        setLayout()
        setupButtonEvent()
    }
    func setUIColor() {
        label.textColor = UIColor(named: "LabelTextColor")
        self.backgroundColor = UIColor(named: "CellBackgroundColor")
    }
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    override func prepareForReuse() {
        label.text = nil
        checkView.currentProgress = 0
        checkBtn.isEnabled = true
    }
    func configure(with model: FirebaseDataModel) {
        self.name = model.name
        label.text = model.name
        guard let done = model.done else { return }
        if done {
            checkView.currentProgress = 1
            checkBtn.isEnabled = false
        }
    }

}
