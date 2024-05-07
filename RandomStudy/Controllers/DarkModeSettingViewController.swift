//
//  DarkModeSettingViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 5/6/24.
//

import UIKit

class DarkModeSettingViewController: UIViewController {
//MARK: Property
    private let appearance = UINavigationBarAppearance()
    private let viewModel = DarkModeSettingViewModel()
    private let collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        let cv = UICollectionView(frame: .zero, collectionViewLayout: layout)
        cv.backgroundColor = UIColor(named: "ViewBackgroundColor")
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.register(DarkModeSettingCollectionViewCell.self,
                    forCellWithReuseIdentifier: DarkModeSettingCollectionViewCell.identifier)
        return cv
    }()
    private func addViews() {
        view.addSubview(collectionView)
    }
    private func configureUI() {
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor(named: "LabelTextColor") ]
        appearance.backgroundColor = UIColor(named: "ViewBackgroundColor")
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationItem.standardAppearance = appearance
        self.navigationItem.scrollEdgeAppearance = appearance
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.title = "다크 모드 설정"
    }
    private func setLayout() {
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(named: "ViewBackgroundColor")
        configureUI()
        addViews()
        setLayout()
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
}
// MARK: CollectionView Delegate
extension DarkModeSettingViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.options.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: DarkModeSettingCollectionViewCell.identifier,
                                                            for: indexPath) as? DarkModeSettingCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.backgroundColor = UIColor(named: "CellBackgroundColor")
        cell.configure(viewModel.options[indexPath.row])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        viewModel.changeMode(viewModel.options[indexPath.row])
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
    
}

extension DarkModeSettingViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.layer.frame.width, height: collectionView.layer.frame.height / 5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}
