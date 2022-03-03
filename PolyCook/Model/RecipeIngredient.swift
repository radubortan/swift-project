//
//  RecipeIngredient.swift
//  PolyCook
//
//  Created by Radu Bortan on 03/03/2022.
//

import Foundation

class RecipeIngredient {
    var id : String = UUID().uuidString
    var ingredient : Ingredient
    var quantity : Int
    
    init(ingredient: Ingredient, quantity: Int) {
        self.ingredient = ingredient
        self.quantity = quantity
    }
}
