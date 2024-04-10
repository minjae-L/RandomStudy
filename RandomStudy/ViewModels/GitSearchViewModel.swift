//
//  GitSearchViewModel.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/03/31.
//

import Foundation

enum NetworkError: Error {
    case invalidURL
    case transportError
    case serverError(code: Int)
    case missingData
    case decodingError
}

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
    
    typealias NetworkResult = (Result<Data, NetworkError>) -> ()
    
    func getGitRepositories(str: String, completion: @escaping NetworkResult) {
        // URL 에러 확인
        guard let url = getGitUrl(str: str).url else {
            completion(.failure(.invalidURL))
            return
        }
        var request: URLRequest = URLRequest(url: url)
        request.httpMethod = "GET"
        let dataTask = session.dataTask(with: request) { (data, response, error) in
            // 통신 확인
            guard error == nil else {
                completion(.failure(.transportError))
                return
            }
            // 서버 확인
            let successRange = 200..<300
            guard let statusCode = (response as? HTTPURLResponse)?.statusCode else { return }
            if !successRange.contains(statusCode) {
                completion(.failure(.serverError(code: statusCode)))
                return
            }
            // 데이터 불러오기 성공
            guard let loadedData = data else {
                completion(.failure(.missingData))
                return
            }
            
            // 디코딩 확인
            do {
                let repo: GitSearchRepository = try JSONDecoder().decode(GitSearchRepository.self, from: loadedData)
                self.gitSearchDatas = repo.repositoryItems
                completion(.success(loadedData))
            } catch {
                completion(.failure(.decodingError))
            }
            
        }.resume()
    }
    
}

