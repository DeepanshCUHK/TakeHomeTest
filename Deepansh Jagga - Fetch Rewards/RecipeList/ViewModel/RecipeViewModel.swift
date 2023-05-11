//
//  RecipeViewModel.swift
//  Deepansh Jagga - Fetch Rewards
//
//  Created by deepansh :$ on 05/10/2023.
//

import Foundation

class RecipeViewModel {
        
    var recipes = [Recipe]()
        
    /// Requests recipes for a specified category.
    ///
    /// - Parameters:
    ///   - category: The optional `String` representing the category of recipes to request.
    ///               If `nil`, the function returns immediately without making a request.
    ///   - completion: A closure that's called when the request is complete.
    ///
    /// - Returns: Void.
    func getRecipes(category: String?, completion: @escaping () -> () ) {
        guard let name = category else { return }
        NetworkManager.shared.getRecipes(category: name) { result in
            switch result {
                case .failure(let error):
                    print("Error getting recipes \(error)")
                case .success(let response):
                    self.recipes = response.meals
                    completion()
            }
        }
    }
}
