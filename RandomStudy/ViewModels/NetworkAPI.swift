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

struct Repository: Codable {
    let items: [Items]
}

struct Items: Codable {
    let full_name: String?
    let description: String?
    let owner: Owner
}
struct Owner: Codable {
    let avatar_url: String?
}

class GitData {
    static var data = [Items]()
}

class NetworkManager {
    static let shared = NetworkManager()
    private init() {}
    
    private let api = NetworkAPI()
    private let session = URLSession(configuration: .default)
    
    func getRepositoriesData(str: String) {
        guard let url = api.getRepositoriesAPI(str: str).url else { return }
        print("URL: \(url)")
        session.dataTask(with: url) { (data, response, error) in
            if let data = data {
                do {
                    let repo: Repository = try
                    JSONDecoder().decode(Repository.self, from: data)
                    GitData.data = repo.items
                } catch let error {
                    print(error)
                }
            }
        }.resume()
    }
}
