//
//  RecipeIngredient.swift
//  PolyCook
//
//  Created by Radu Bortan on 03/03/2022.
//

import Foundation

class RecipeIngredient {
    var id : String
    
    //the ingredient being used
    var ingredient : Ingredient
    
    //quantity of the ingredient used in the recipe
    var quantity : Double
    
    init(ingredient: Ingredient, quantity: Double, id : String = UUID().uuidString) {
        self.ingredient = ingredient
        self.quantity = quantity
        self.id = id
    }
}
