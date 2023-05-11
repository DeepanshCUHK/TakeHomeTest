//
//  NetworkManager.swift
//  Deepansh Jagga - Fetch Rewards
//
//  Created by deepansh :$ on 05/10/2023.
//

import Foundation
import UIKit

class NetworkManager {

    static let shared = NetworkManager()
    
    /// Requests recipes for a specified category.
    ///
    /// - Parameters:
    ///   - category: The category of recipes to request.
    ///   - completion: A closure that's called when the request is complete.
    ///                 On success, the closure is called with `.success` and a `RecipeResponse` object.
    ///                 On failure, the closure is called with `.failure` and an `Error` object.
    ///
    /// - Returns: Void.
    func getRecipes(category: String, completion: @escaping (Result<RecipeResponse, Error>) -> () ) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(category)"
        netWorkRequest(urlString: urlString, completion: completion)
    }
    
    /// Requests detailed information for a specified recipe.
    ///
    /// - Parameters:
    ///   - id: The identifier of the recipe to request details for.
    ///   - completion: A closure that's called when the request is complete.
    ///                 On success, the closure is called with `.success` and a `RecipeDetailResponse` object.
    ///                 On failure, the closure is called with `.failure` and an `Error` object.
    ///
    /// - Returns: Void.
    func getRecipeDetails(id: String, completion: @escaping (Result<RecipeDetailResponse, Error>) -> () ) {
        let urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(id)"
        netWorkRequest(urlString: urlString, completion: completion)
    }
    
    /// Performs a network request to fetch data from a specified URL and decodes the JSON response to a specified type.
    ///
    /// - Parameters:
    ///   - urlString: The string representation of the URL to fetch data from.
    ///   - completion: A closure that's called when the request is complete.
    ///                 On success, the closure is called with `.success` and an instance of the requested type.
    ///                 On failure, the closure is called with `.failure` and an `Error` object.
    ///
    /// - Returns: Void.
    fileprivate func netWorkRequest<T: Decodable>(urlString: String, completion: @escaping (Result<T, Error>) -> () ) {
        guard let url = URL(string: urlString) else { return }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
            
            guard let data = data else { return }
            
            do {
                let decoded = try JSONDecoder().decode(T.self, from: data)
                DispatchQueue.main.async {
                    completion(.success(decoded))
                }
            }
            catch let error {
                print("Could not translate the data to the requested type. Reason: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    completion(.failure(error))
                }
            }
        }.resume()
    }
}
