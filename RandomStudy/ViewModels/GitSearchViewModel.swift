//
//  GitSearchViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/03/31.
//

import Foundation
protocol GitSearchViewModelDelegate: AnyObject {
    func didUpdatedGitSearch()
}
final class GitSearchViewModel {
    weak var delegate: GitSearchViewModelDelegate?
    
    private(set) var gitSearchDatas = [GitSearchItems]() {
        didSet {
            delegate?.didUpdatedGitSearch()
        }
    }
    var dataCount: Int {
        return gitSearchDatas.count
    }
    // URLComponents 구성
    private func getGitUrl(str: String?) -> URLComponents {
        let scheme = "https"
        let host = "api.github.com"
        let path = "/search/repositories"
        
        var components = URLComponents()
        components.scheme = scheme
        components.host = host
        components.path = path
        
        components.queryItems = [
            URLQueryItem(name: "q", value: str)
        ]
        return components
    }
    // URLSession 구성
    private let session = URLSession(configuration: URLSessionConfiguration.default)
    
    func getGitRepositories(str: String, completion: @escaping () -> ()) {
        guard let url = getGitUrl(str: str).url else { return }
        let dataTask = session.dataTask(with: url) { (data, response, error) in
            // 에러 발생하면 종료
            guard error == nil else { return }
            // 정상적인 네트워크 범주 판단
            let successRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode,
                  successRange.contains(statusCode) else { return }
            
            // 정상 데이터 받기
            guard let loadedData = data else { return }
            
            // JSON data Decode
            do {
                let repo: GitSearchRepository = try JSONDecoder().decode(GitSearchRepository.self,
                                     from: loadedData)
                self.gitSearchDatas = repo.repositoryItems
                completion()
            } catch let error {
                print(error)
            }
            
        }.resume()
    }
    
}

