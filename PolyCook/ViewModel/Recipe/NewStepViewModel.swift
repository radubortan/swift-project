//
//  NewStepViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 27/02/2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class NewStepViewModel : ObservableObject {
    
    private let firestore  = Firestore.firestore()
    
    var listIntent : CreateRecipeIntent
    
    @Published var isRecipe = false
    @Published var nomEtape = ""
    @Published var duration = 1
    @Published var description = ""
    
    @Published var selectedIngredient = Ingredient(id: "", nomIng: "", nomCat: "", nomCatAllerg: "", unite: "")
    @Published var quantity : Double = 1
    
    @Published var selectedRecipe = Recette(nbCouverts: 0, nomAuteur: "", nomCatRecette: "", nomRecette: "", etapes: [])
    @Published var subrecipeQuantity : Int = 1
    
    //list of the recipes available
    @Published var recipes : [Recette]
    
    var recipeIngredients : [RecipeIngredient] {
        return RecipeManipulator.extractIngredients(steps: selectedRecipe.etapes)
    }
    
    //list of the ingredients available
    @Published var ingredients : [Ingredient] = []
    
    //list of the ingredients used in the recipe
    @Published var ingredientsList : [RecipeIngredient] = []
    
    //formats the entered values
    let numberFormatter = NumberFormatter()
    
    
    func deleteIngredient(at indexSet: IndexSet) {
        withAnimation {
            ingredientsList.remove(atOffsets: indexSet)
        }
    }
    
    init(listVm: CreateRecipeViewModel, recipes: [Recette]) {
        numberFormatter.numberStyle = .decimal
        self.listIntent = CreateRecipeIntent()
        self.listIntent.addObserver(viewModel: listVm)
        self.recipes = recipes
        if !self.recipes.isEmpty {
            self.selectedRecipe = self.recipes[0]
        }
        Task {
            loadIngredients()
        }
    }
    
    func addIngredient(ingredient: Ingredient, quantity: Double) {
        let foundIngredient = ingredientsList.filter{$0.ingredient.nomIng == ingredient.nomIng}
        if foundIngredient.isEmpty {
            ingredientsList.append(RecipeIngredient(ingredient: ingredient, quantity: quantity))
        }
        else {
            foundIngredient[0].quantity += quantity
            //to force the quantity to update in the view
            objectWillChange.send()
        }
    }
    
    func loadIngredients() {
//        var initializedIngredient = false
        firestore.collection("ingredients")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                self.ingredients = documents.map{
                    (doc) -> Ingredient in
                    let createdIngredient = Ingredient(id: doc.documentID,
                                                      nomIng: doc["nomIng"] as? String ?? "",
                                                      nomCat: doc["nomCat"] as? String ?? "",
                                                      nomCatAllerg: doc["nomCatAllerg"] as? String ?? nil,
                                                      unite: doc["unite"] as? String ?? "" )
//                    if !initializedIngredient {
//                        self.selectedIngredient = createdIngredient
//                        initializedIngredient.toggle()
//                    }
                    return createdIngredient
                }
                self.ingredients.sort(by : {$0.nomIng > $1.nomIng})
                if !self.ingredients.isEmpty {
                    self.selectedIngredient = self.ingredients.last!
                }
            }
    }
}
