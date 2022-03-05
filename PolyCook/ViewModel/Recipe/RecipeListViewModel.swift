//
//  RecipeListViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 26/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class RecipeListViewModel : ObservableObject, Subscriber {
    
    init(){
        Task{
            loadRecipes()
        }
    }
    
    private let firestore  = Firestore.firestore()

    
    typealias Input = RecipeListIntentState
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: RecipeListIntentState) -> Subscribers.Demand {
            switch input{
            case .ready:
                break
            case .addingRecipe(let recette):
                self.recipes.append(recette)
                self.objectWillChange.send()
                self.addRecipe(recipe: recette)
            }
            return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    @Published var recipes : [Recette] = []
    @Published var enteredText : String = ""
    
    @Published var toBeDeleted : IndexSet?
    @Published var showingDeleteAlert = false
    
    //filter states
    @Published var showMealFilter = false
    @Published var showIngredientFilter = false
    @Published var mealFilters = [FilterItem(title: "Entrée"), FilterItem(title: "Principal"), FilterItem(title: "Dessert")]
    @Published var ingredientFilters = [FilterItem(title: "Pomme"), FilterItem(title: "Oeuf"), FilterItem(title: "Pâtes"), FilterItem(title: "Poisson"), FilterItem(title: "Tomate"), FilterItem(title: "Oignon"), FilterItem(title: "Courgette")]
    
    
    func showConfirmation(at indexSet : IndexSet) {
        self.toBeDeleted = indexSet
        self.showingDeleteAlert = true
    }
    
    func getNSDictionaryFromRecipe(recipe: Recette) -> NSDictionary{
        var steps = [NSDictionary]()
        for step in recipe.etapes {
            
            //case InExtenso
            if let inExtenso = step as? InExtensoStep {
                var ingredients = [NSDictionary]()
                for ingredientRecette in inExtenso.ingredients {
                    let ingredient = ingredientRecette.ingredient
                    if ingredient.nomCatAllerg != nil{
                        ingredients.append(["nomIng": ingredient.nomIng,"nomCat": ingredient.nomCat,"nomCatAllerg": ingredient.nomCatAllerg ?? "","unite":ingredient.unite,"prixUnitaire":ingredient.prixUnitaire,"quantite": ingredientRecette.quantity])
                    }
                    else{
                        ingredients.append(["nomIng": ingredient.nomIng,"nomCat": ingredient.nomCat,"unite":ingredient.unite,"prixUnitaire":ingredient.prixUnitaire,"quantite": ingredientRecette.quantity])
                        
                    }
                }
                steps.append(["nomEtape": inExtenso.nomEtape ?? "","duree": inExtenso.duree,"description": inExtenso.description,"ingredients":ingredients])
            }
            
            //case Recipe
            if let recipeStep = step as? Recette{
                steps.append(getNSDictionaryFromRecipe(recipe: recipeStep))
            }
        }

        return ["nomRecette":recipe.nomRecette,"nomAuteur": recipe.nomAuteur , "nomCatRecette": recipe.nomCatRecette, "nbCouverts":recipe.nbCouverts, "steps" : steps]
    }
    
    func addRecipe(recipe: Recette){
        var steps = [NSDictionary]()
        for step in recipe.etapes {

            //case InExtenso
            if let inExtenso = step as? InExtensoStep {
                var ingredients = [NSDictionary]()
                for ingredientRecette in inExtenso.ingredients {
                    let ingredient = ingredientRecette.ingredient
                    if ingredient.nomCatAllerg != nil{
                        ingredients.append(["nomIng": ingredient.nomIng,"nomCat": ingredient.nomCat,"nomCatAllerg": ingredient.nomCatAllerg ?? "","unite":ingredient.unite,"prixUnitaire":ingredient.prixUnitaire,"quantite": ingredientRecette.quantity])
                    }
                    else{
                        ingredients.append(["nomIng": ingredient.nomIng,"nomCat": ingredient.nomCat,"unite":ingredient.unite,"prixUnitaire":ingredient.prixUnitaire,"quantite": ingredientRecette.quantity])
                        
                    }
                }
                steps.append(["nomEtape": inExtenso.nomEtape ?? "","duree": inExtenso.duree,"description": inExtenso.description,"ingredients":ingredients])
                
                // Ajouter les ingrédients
            }
            
            //case Recipe
            if let recipeStep = step as? Recette{
                steps.append(getNSDictionaryFromRecipe(recipe: recipeStep))
            }
        }
        
        
        firestore.collection("recipes").addDocument(data: ["nomRecette":recipe.nomRecette,"nomAuteur": recipe.nomAuteur , "nomCatRecette": recipe.nomCatRecette, "nbCouverts":recipe.nbCouverts, "steps" : steps]) {
            error in
            if error == nil {
                // no error
            }
        }

    }
    
    func getRecipeFromNSDictionary(recipe: NSDictionary)->Recette{
        let stepsDocument = recipe["steps"] as? [NSDictionary] ?? []
        let steps = stepsDocument.map{
            (step) -> Step in
            if step["nomRecette"] != nil{
                return getRecipeFromNSDictionary(recipe: step)
            }
            else{
                let ingredientsDocument = step["ingredients"] as? [NSDictionary] ?? []
                let ingredients = ingredientsDocument.map{
                    (ingredient) -> RecipeIngredient in
                    if ingredient["nomCatAllerg"] != nil{
                        let ingredientModel = Ingredient(id: UUID().uuidString, nomIng: ingredient["nomIng"] as? String ?? "", nomCat: ingredient["nomCat"] as? String ?? "", nomCatAllerg: ingredient["nomCatAllerg"] as? String ?? nil, unite: ingredient["unite"] as? String ?? "", prixUnitaire: ingredient["prixUnitaire"] as? Float ?? 0.0, quantite: ingredient["quantite"] as? Double ?? 0.0)
                        return RecipeIngredient(ingredient: ingredientModel, quantity: ingredient["quantite"] as? Double ?? 0.0, id: UUID().uuidString)
                    }
                    else{
                        let ingredientModel = Ingredient(id: UUID().uuidString, nomIng: ingredient["nomIng"] as? String ?? "", nomCat: ingredient["nomCat"] as? String ?? "",nomCatAllerg: nil, unite: ingredient["unite"] as? String ?? "", prixUnitaire: ingredient["prixUnitaire"] as? Float ?? 0.0, quantite: ingredient["quantite"] as? Double ?? 0.0)
                        return RecipeIngredient(ingredient: ingredientModel, quantity: ingredient["quantite"] as? Double ?? 0.0, id: UUID().uuidString)
                    }
                    
                }
                
                return InExtensoStep(nomEtape: step["nomEtape"] as? String ?? "", duree: step["duree"] as? Int ?? 0, description: step["description"] as? String ?? "",ingredients:ingredients,id: UUID().uuidString)
            }
            
        }
        return Recette(
            nbCouverts: recipe["nbCouverts"] as? Int ?? 0, nomAuteur: recipe["nomAuteur"] as? String ?? "", nomCatRecette: recipe["nomCatRecette"] as? String ?? "", nomRecette: recipe["nomRecette"] as? String ?? "", etapes: steps)
    }
    
    func loadRecipes() {
        firestore.collection("recipes")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                self.recipes = documents.map{
                    (doc) -> Recette in
                    let stepsDocument = doc["steps"] as? [NSDictionary] ?? []
                    let steps = stepsDocument.map{
                        (step) -> Step in
                        if step["nomRecette"] != nil{
                            return self.getRecipeFromNSDictionary(recipe: step)
                        }
                        else{
                            
                            // Ajouter les ingrédients
                            let ingredientsDocument = step["ingredients"] as? [NSDictionary] ?? []
                            let ingredients = ingredientsDocument.map{
                                (ingredient) -> RecipeIngredient in
                                if ingredient["nomCatAllerg"] != nil{
                                    let ingredientModel = Ingredient(id: UUID().uuidString, nomIng: ingredient["nomIng"] as? String ?? "", nomCat: ingredient["nomCat"] as? String ?? "", nomCatAllerg: ingredient["nomCatAllerg"] as? String ?? "", unite: ingredient["unite"] as? String ?? "", prixUnitaire: ingredient["prixUnitaire"] as? Float ?? 0.0, quantite: ingredient["quantite"] as? Double ?? 0.0)
                                    return RecipeIngredient(ingredient: ingredientModel, quantity: ingredient["quantite"] as? Double ?? 0.0, id: UUID().uuidString)
                                }
                                else{
                                    let ingredientModel = Ingredient(id: UUID().uuidString, nomIng: ingredient["nomIng"] as? String ?? "", nomCat: ingredient["nomCat"] as? String ?? "",nomCatAllerg: nil, unite: ingredient["unite"] as? String ?? "", prixUnitaire: ingredient["prixUnitaire"] as? Float ?? 0.0, quantite: ingredient["quantite"] as? Double ?? 0.0)
                                    return RecipeIngredient(ingredient: ingredientModel, quantity: ingredient["quantite"] as? Double ?? 0.0, id: UUID().uuidString)
                                }
                                
                            }
                            
                            return InExtensoStep(nomEtape: step["nomEtape"] as? String ?? "", duree: step["duree"] as? Int ?? 0, description: step["description"] as? String ?? "",ingredients: ingredients,id: UUID().uuidString)
                        }
                        
                    }
                    return Recette(
                        nbCouverts: doc["nbCouverts"] as? Int ?? 0, nomAuteur: doc["nomAuteur"] as? String ?? "", nomCatRecette: doc["nomCatRecette"] as? String ?? "", nomRecette: doc["nomRecette"] as? String ?? "", etapes: steps,id: doc.documentID)
                }
            }
    }
}
