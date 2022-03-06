//
//  EditInExtensoStepViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 06/03/2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift

class EditInExtensoStepViewModel : ObservableObject {
    private let firestore  = Firestore.firestore()
    
    var listIntent : CreateRecipeIntent
    
    var step : InExtensoStep
    
    @Published var nomEtape : String
    @Published var duration : Int
    @Published var description : String
    
    @Published var selectedIngredient = Ingredient(id: "", nomIng: "", nomCat: "", nomCatAllerg: "", unite: "")
    @Published var quantity : Double = 1
    
    //list of the ingredients available
    @Published var ingredients : [Ingredient] = []
    
    //list of the ingredients used in the step
    @Published var ingredientsList : [RecipeIngredient] = []
    
    //formats the entered values
    let numberFormatter = NumberFormatter()
    
    init(listVm: CreateRecipeViewModel, step: InExtensoStep) {
        self.step = step
        self.nomEtape = step.nomEtape!
        self.duration = step.duree
        self.description = step.description
        self.ingredientsList = step.ingredients
        
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
    
    func deleteIngredient(at indexSet: IndexSet) {
        withAnimation {
            ingredientsList.remove(atOffsets: indexSet)
        }
    }
    
    func loadIngredients() {
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
                    return createdIngredient
                }
                self.ingredients.sort(by : {$0.nomIng > $1.nomIng})
                if !self.ingredients.isEmpty {
                    self.selectedIngredient = self.ingredients.last!
                }
            }
    }
}
