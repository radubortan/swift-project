//
//  RecipeIngredientListViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 05/03/2022.
//

import Foundation

class RecipeIngredientListViewModel : ObservableObject{
    let steps : [Step]
    
    var hasNormalIngredients : Bool {
        return ingredients.contains(where: {$0.ingredient.nomCatAllerg == nil})
    }
    var hasAllergens : Bool {
        return ingredients.contains(where: {$0.ingredient.nomCatAllerg != nil})
    }
    
    init(steps : [Step]){
        self.steps = steps
    }
    
    var ingredients : [RecipeIngredient] {
        return RecipeManipulator.extractIngredients(steps: self.steps)
    }
}
