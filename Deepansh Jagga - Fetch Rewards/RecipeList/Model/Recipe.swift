//
//  Recipe.swift
//  Deepansh Jagga - Fetch Rewards
//
//  Created by deepansh :$ on 05/10/2023.
//
import Foundation

struct Recipe: Decodable, Hashable {
    var recipeId: String?
    var recipeName: String?
    var recipeImage: String?

    enum CodingKeys: String, CodingKey {
        case recipeId = "idMeal"
        case recipeName = "strMeal"
        case recipeImage = "strMealThumb"
    }
}

struct RecipeResponse: Decodable {
    let meals: [Recipe]
}
