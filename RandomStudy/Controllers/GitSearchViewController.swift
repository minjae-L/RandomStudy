//
//  GitSearchViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/01/18.
//

import UIKit

class GitSearchViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private let resultCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 57/255, green: 63/255, blue: 92/255, alpha: 1)

        return collectionView
    }()

    func setupUI() {
        view.backgroundColor = UIColor(red: 57/255, green: 63/255, blue: 92/255, alpha: 1)
        self.navigationItem.title = "Git search"
        
        // SearchController
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "repository"
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        // CollectionView
        self.resultCollectionView.translatesAutoresizingMaskIntoConstraints = false
        self.resultCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.resultCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.resultCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.resultCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        self.resultCollectionView.register(GitSearchCollectionViewCell.self
                                           , forCellWithReuseIdentifier: GitSearchCollectionViewCell.idendifier)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resultCollectionView)
        setupUI()
    }

}
extension GitSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width-20, height: view.frame.size.height/5)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
    }
}

extension GitSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return GitData.data.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: GitSearchCollectionViewCell.idendifier, for: indexPath) as? GitSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        let result = GitData.data[indexPath.row]
        cell.configure(with: result)
        
        return cell
    }
    
    
}


extension GitSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("DEBUG PRINT:", searchController.searchBar.text)
        DispatchQueue.main.async { [weak self] in
            NetworkManager.shared.getRepositoriesData(str: searchController.searchBar.text ?? "")
            self?.resultCollectionView.reloadData()
        }
    }
    
}
