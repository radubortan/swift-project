//
//  IngredientExtractor.swift
//  PolyCook
//
//  Created by Radu Bortan on 05/03/2022.
//

import Foundation

class IngredientExtractor {
    //extracts the InExtensoStep nested inside of the recipe
    private static func extractSteps(steps : [Step]) -> [InExtensoStep] {
        var extractedSteps : [InExtensoStep] = []
        for step in steps {
            if step is InExtensoStep {
                extractedSteps.append(step as! InExtensoStep)
            }
            else {
                let recetteCast = step as! Recette
                let subSteps = extractSteps(steps: recetteCast.etapes)
                for subStep in subSteps {
                    extractedSteps.append(subStep)
                }
            }
        }
        return extractedSteps
    }
    
    //extracts the ingredients of a recipe
    static func extractIngredients(steps : [Step]) -> [RecipeIngredient] {
        //
        let extractedSteps = extractSteps(steps: steps)
        
        //making a deep copy of the steps because quantity will be modified but we don't want to modify the quantities in the original recipe
        var copiedSteps : [InExtensoStep] = []
        for step in extractedSteps {
            let stepIngredients = copyRecipeIngredients(recipeIngredients: step.ingredients)
            copiedSteps.append(InExtensoStep(nomEtape: step.nomEtape!, duree: step.duree, description: step.description, ingredients: stepIngredients, id: step.id))
        }
        
        var extractedIngredients : [RecipeIngredient] = []
        
        for step in copiedSteps {
            for recipeIngredient in step.ingredients {
                let foundIngredient = extractedIngredients.filter{$0.ingredient.nomIng == recipeIngredient.ingredient.nomIng}
                if foundIngredient.isEmpty {
                    extractedIngredients.append(recipeIngredient)
                }
                else {
                    foundIngredient[0].quantity += recipeIngredient.quantity
                    //to force the quantity to update in the view
//                    objectWillChange.send()
                }
            }
        }
        return extractedIngredients
    }
    
    //makes a deep enough copy of the steps so each RecipeIngredient has its own reference in memory
    private static func copyRecipeIngredients(recipeIngredients : [RecipeIngredient]) -> [RecipeIngredient] {
        var copiedRecipeIngredients : [RecipeIngredient] = []
        for recipeIngredient in recipeIngredients {
            copiedRecipeIngredients.append(RecipeIngredient(ingredient: recipeIngredient.ingredient, quantity: recipeIngredient.quantity))
        }
        return copiedRecipeIngredients
    }
}
