//
//  Network.swift
//  RandomStudy
//
//  Created by 이민재 on 2024/01/19.
//

import Foundation

struct NetworkAPI {
    static let schema = "https"
    static let host = "api.github.com"
    static let path = "/search/repositories"
    
    func getRepositoriesAPI(str: String?) -> URLComponents {
        var components = URLComponents()
        components.scheme = NetworkAPI.schema
        components.host = NetworkAPI.host
        components.path = NetworkAPI.path
        
        components.queryItems = [
            URLQueryItem(name: "q", value: str)
        ]
        return components
    }
}

class GitData {
    static var data = [GitSearchItems]()
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let api = NetworkAPI()
    private let session = URLSession(configuration: .default)
    
    func getRepositoriesData(str: String, completion: @escaping ([GitSearchItems]) -> ()) {
        guard let url = api.getRepositoriesAPI(str: str).url else { return }
        session.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let data = data {
                    do {
                        let repo: GitSearchRepository = try
                        JSONDecoder().decode(GitSearchRepository.self, from: data)
                        completion(repo.repositoryItems)
                    } catch let error {
                        print(error)
                    }
                }
            }
        }.resume()
    }
}
