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
    
    @Published var selectedRecipe = Recette(nbCouverts: 1, nomAuteur: "Radu", nomCatRecette: "Dessert", nomRecette: "Sauce", etapes: [
        InExtensoStep(nomEtape: "Couper fruits", duree: 10, description: "Couper", ingredients: [RecipeIngredient(ingredient: Ingredient(id: "sdfsdf", nomIng: "Pomme", nomCat: "Fruit", nomCatAllerg: nil, unite: "Kg"), quantity: 1)]),
        InExtensoStep(nomEtape: "Mélanger", duree: 10, description: "desc", ingredients: [RecipeIngredient(ingredient: Ingredient(id: "fsdfdsfs", nomIng: "Pomme", nomCat: "Fruit", nomCatAllerg: nil, unite: "Kg"), quantity: 1)])])
    
    @Published var subrecipeQuantity : Int = 1
    
    //list of the recipes available
    @Published var recipes : [Recette] = [
        Recette(nbCouverts: 1, nomAuteur: "Radu", nomCatRecette: "Dessert", nomRecette: "Sauce", etapes: [
        InExtensoStep(nomEtape: "Couper fruits", duree: 10, description: "Couper", ingredients: [RecipeIngredient(ingredient: Ingredient(id: "sdfsdf", nomIng: "Pomme", nomCat: "Fruit", nomCatAllerg: nil, unite: "Kg"), quantity: 1)]),
        InExtensoStep(nomEtape: "Mélanger", duree: 10, description: "desc", ingredients: [RecipeIngredient(ingredient: Ingredient(id: "fsdfdsfs", nomIng: "Pomme", nomCat: "Fruit", nomCatAllerg: nil, unite: "Kg"), quantity: 1)])]),
        
        Recette(nbCouverts: 2, nomAuteur: "Radu", nomCatRecette: "Principal", nomRecette: "Pates", etapes: [
            InExtensoStep(nomEtape: "Faire cuire pates", duree: 20, description: "Mettre dans de l'eau", ingredients: [RecipeIngredient(ingredient: Ingredient(id: "dgfza", nomIng: "Pates", nomCat: "", nomCatAllerg: nil, unite: "Kg"), quantity: 1), RecipeIngredient(ingredient: Ingredient(id: "zerz", nomIng: "Tomate", nomCat: "Légume", nomCatAllerg: nil, unite: "Kg"), quantity: 0.5)]),
            InExtensoStep(nomEtape: "Faire cuire pates", duree: 20, description: "Mettre dans de l'eau", ingredients: [RecipeIngredient(ingredient: Ingredient(id: "dgfza", nomIng: "Pates", nomCat: "", nomCatAllerg: nil, unite: "Kg"), quantity: 1), RecipeIngredient(ingredient: Ingredient(id: "zerz", nomIng: "Tomate", nomCat: "Légume", nomCatAllerg: nil, unite: "Kg"), quantity: 0.5)]),
            InExtensoStep(nomEtape: "Faire cuire pates", duree: 20, description: "Mettre dans de l'eau", ingredients: [RecipeIngredient(ingredient: Ingredient(id: "dgfza", nomIng: "Pates", nomCat: "", nomCatAllerg: nil, unite: "Kg"), quantity: 1), RecipeIngredient(ingredient: Ingredient(id: "zerz", nomIng: "Tomate", nomCat: "Légume", nomCatAllerg: nil, unite: "Kg"), quantity: 0.5)])
        ])
    ]
    
    var recipeIngredients : [RecipeIngredient] {
        return IngredientExtractor.extractIngredients(steps: selectedRecipe.etapes)
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
    
    init(listVm: CreateRecipeViewModel) {
        numberFormatter.numberStyle = .decimal
        self.listIntent = CreateRecipeIntent()
        self.listIntent.addObserver(viewModel: listVm)
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
        var initializedIngredient = false
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
                    if !initializedIngredient {
                        self.selectedIngredient = createdIngredient
                        initializedIngredient.toggle()
                    }
                    return createdIngredient
                }
            }
    }
}
