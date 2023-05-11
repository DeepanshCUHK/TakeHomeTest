//
//  RecipeDetailViewModel.swift
//  Deepansh Jagga - Fetch Rewards
//
//  Created by deepansh :$ on 05/10/2023.
//

import Foundation

class RecipeDetailViewModel {
        
    var recipeDetails: RecipeDetail?
        
    /// Requests detailed information for a specified recipe.
    ///
    /// - Parameters:
    ///   - id: The optional `String` representing the identifier of the recipe to request details for.
    ///         If `nil`, the function returns immediately without making a request.
    ///   - completion: A closure that's called when the request is complete.
    ///
    /// - Returns: Void.
    func getRecipeDetails(id: String?, completion: @escaping () -> () ) {
        guard let id = id else { return }
        NetworkManager.shared.getRecipeDetails(id: id) { result in
            switch result {
                case .failure(let error):
                    print("Error getting recipes details \(error)")
                case .success(let response):
                    self.recipeDetails = response.meals[0]
                    completion()
            }
        }
    }
}
