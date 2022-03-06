//
//  InExtensoStepViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 05/03/2022.
//

import Foundation

class InExtensoStepViewModel : ObservableObject{
    let step : InExtensoStep
    
    init(step: InExtensoStep) {
        self.step = step
    }
    
    var hasNormalIngredients : Bool {
        return step.ingredients.contains(where: {$0.ingredient.nomCatAllerg == nil})
    }
    
    var hasAllergens : Bool {
        return step.ingredients.contains(where: {$0.ingredient.nomCatAllerg != nil})
    }
}
