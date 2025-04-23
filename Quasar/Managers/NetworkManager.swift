//
//  NetworkManager.swift
//  Quasar
//
//  Created by Basem El kady on 3/5/22.
//

import Foundation
import UIKit

class NetworkManager {
    
    static let shared = NetworkManager()

    private var cache = NSCache <NSString, UIImage>()
    
    func fetchArticleData (with url: String, completion: @escaping (Result<[Article], QuasarError>) -> Void) {
        
        guard let url = URL(string: url) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidResponse))
                }
                return
            }
            guard let data = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
            do {
                let fetchedArticles = try JSONDecoder().decode(ArticleResponse.self, from: data)
                completion(.success(fetchedArticles.results))
            } catch {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return
            }
        }
        task.resume()
    }
    
    func fetchArticleImageWith(url: String, completion: @escaping (Result<UIImage, QuasarError>) -> Void ){
        
        if let cachedImage = cache.object(forKey: url as NSString) {
            completion(.success(cachedImage))
            return
        }
        guard let ImageUrl = URL(string: url) else {
            DispatchQueue.main.async {
                completion(.failure(.invalidURL))
            }
            return }
        let task = URLSession.shared.dataTask(with: ImageUrl) { data, response, error in
            guard error == nil else {
                DispatchQueue.main.async {
                    completion(.failure(.unableToComplete))
                }
                return
            }
            guard let ImageData = data else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return }
            guard let titleImage = UIImage(data: ImageData) else {
                DispatchQueue.main.async {
                    completion(.failure(.invalidData))
                }
                return }
            self.cache.setObject(titleImage, forKey: url as NSString)
            DispatchQueue.main.async {
                completion(.success(titleImage))
            }
        }
        task.resume()
    }
}
