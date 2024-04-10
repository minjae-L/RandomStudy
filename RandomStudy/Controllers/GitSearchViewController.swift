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
        
        // NavigationController
        self.navigationItem.title = "Git search"
        let appearance = UINavigationBarAppearance()
        appearance.backgroundColor = UIColor(red: 57/255, green: 63/255, blue: 92/255, alpha: 1)
        appearance.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.prefersLargeTitles = false
        self.navigationController?.navigationBar.isTranslucent = false
        self.navigationItem.largeTitleDisplayMode = .never
        self.navigationController?.navigationBar.standardAppearance = appearance
        self.navigationController?.navigationBar.scrollEdgeAppearance = appearance
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        
        // SearchController
        self.searchController.searchResultsUpdater = self
        self.searchController.obscuresBackgroundDuringPresentation = false
        self.searchController.hidesNavigationBarDuringPresentation = false
        self.searchController.searchBar.placeholder = "repository"
        self.searchController.searchBar.showsCancelButton = false
        self.searchController.searchBar.showsScopeBar = true
        self.searchController.searchBar.delegate = self
        self.searchController.searchBar.searchTextField.backgroundColor = UIColor(red: 57/255, green: 63/255, blue: 92/255, alpha: 1)
        self.searchController.searchBar.searchTextField.textColor = .white
        self.searchController.searchBar.backgroundColor = UIColor(red: 57/255, green: 63/255, blue: 92/255, alpha: 1)
        self.searchController.searchBar.searchTextField.attributedPlaceholder = NSAttributedString(string: "repository", attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        
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
        guard let urlString = viewModel.gitSearchDatas[indexPath.row].htmlUrl, let url = URL(string: urlString) else { return }
        let safariView: SFSafariViewController = SFSafariViewController(url: url)
        self.present(safariView, animated: true, completion: nil)
    }
    
}

extension GitSearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        let text = searchBar.text ?? ""
        viewModel.getGitRepositories(str: text) { result in
            switch result {
            case .success(let data):
                self.didUpdatedGitSearch()
                print("Success")
            case .failure(.invalidURL):
                print("invalidURL Error")
            case .failure(.transportError):
                print("transport Error")
            case .failure(.serverError(code: let code)):
                print("server Error \(code)")
            case .failure(.decodingError):
                print("decoding Error")
            case .failure(.missingData):
                print("missingData Error")
            }
        }
        
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
