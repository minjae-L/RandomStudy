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
        collectionView.backgroundColor = .white

        return collectionView
    }()

    func setupUI() {
        view.backgroundColor = .white
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
        self.resultCollectionView.register(UICollectionViewCell.self
                                           , forCellWithReuseIdentifier: "CollectionCell")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resultCollectionView)
        setupUI()
    }

}
extension GitSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.size.width, height: view.frame.size.height/10)
    }
}

extension GitSearchViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 9
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: "CollectionCell", for: indexPath)
        cell.backgroundColor = .black
        
        return cell
    }
    
    
}


extension GitSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("DEBUG PRINT:", searchController.searchBar.text)
    }
    
}
