//
//  GitSearchViewController.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/01/18.
//

import UIKit
import SafariServices

class GitSearchViewController: UIViewController {

    private let searchController = UISearchController(searchResultsController: nil)
    private let resultCollectionView: UICollectionView = {
        let flowLayout = UICollectionViewFlowLayout()
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: flowLayout)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.backgroundColor = UIColor(red: 57/255, green: 63/255, blue: 92/255, alpha: 1)

        return collectionView
    }()
    private var viewModel = GitSearchViewModel()

    func setupUI() {
        view.backgroundColor = UIColor(red: 57/255, green: 63/255, blue: 92/255, alpha: 1)
        self.navigationItem.title = "Git search"
        
        // SearchController
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "repository"
        self.searchController.searchBar.showsCancelButton = false
        self.searchController.searchBar.showsScopeBar = true
        self.searchController.searchBar.delegate = self
        self.navigationItem.searchController = searchController
        self.definesPresentationContext = false
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        // CollectionView
        self.resultCollectionView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        self.resultCollectionView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        self.resultCollectionView.leadingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leadingAnchor).isActive = true
        self.resultCollectionView.trailingAnchor.constraint(equalTo: view.safeAreaLayoutGuide.trailingAnchor).isActive = true
        self.resultCollectionView.dataSource = self
        self.resultCollectionView.delegate = self
        self.resultCollectionView.register(GitSearchCollectionViewCell.self,
                                           forCellWithReuseIdentifier: GitSearchCollectionViewCell.idendifier)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(resultCollectionView)
        setupUI()
    }

}
// MARK: - CollectionView UI configure extension
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
        return viewModel.dataCount
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = resultCollectionView.dequeueReusableCell(withReuseIdentifier: GitSearchCollectionViewCell.idendifier, for: indexPath) as? GitSearchCollectionViewCell else {
            return UICollectionViewCell()
        }
        cell.configure(with: viewModel.gitSearchDatas[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let url = NSURL(string: viewModel.gitSearchDatas[indexPath.row].htmlUrl!)
        let safariView: SFSafariViewController = SFSafariViewController(url: url as! URL)
        self.present(safariView, animated: true, completion: nil)
    }
    
}

extension GitSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        viewModel.getGitRepositories(str: text, completion: {
            self.didUpdatedGitSearch()
        })
    }
}
extension GitSearchViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        print("DEBUG PRINT:", searchController.searchBar.text)
    }
    
}
// MARK: - ViewModel Delegate
extension GitSearchViewController: GitSearchViewModelDelegate {
    func didUpdatedGitSearch() {
        DispatchQueue.main.async {
            [weak self] in
            self?.resultCollectionView.reloadData()
        }
    }
}
