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
    private let firestore  = Firestore.firestore()
    
    init(){
        Task{
            loadRecipes()
            loadIngredients()
        }
    }
    
    //MARK: - Intent
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
    
    
    //MARK: - Published
    @Published var recipes : [Recette] = []
    @Published var enteredText : String = ""
    
    @Published var toBeDeleted : IndexSet?
    @Published var showingDeleteAlert = false
    
    //filter states
    @Published var showMealFilter = false
    @Published var showIngredientFilter = false
    
    
    @Published var mealFilters = Filter(filters: [FilterItem(title: "Entrée"), FilterItem(title: "Principal"), FilterItem(title: "Dessert")])
    @Published var ingredientFilters : Filter = Filter(filters: [])

    
    var filters: [FilterItem] = []
    
    //recipes being shown in the list
    var filterResults: [Recette] {
        var checkedMealTypes : [String] = []
        for filter in mealFilters.filters {
            if filter.checked {
                checkedMealTypes.append(filter.title)
            }
        }
        
        var checkedIngredients : [String] = []
        for filter in ingredientFilters.filters {
            if filter.checked {
                checkedIngredients.append(filter.title)
            }
        }
        
        if enteredText.isEmpty {
            var finalResult : [Recette] = []
            for recipe in recipes {
                if checkedMealTypes.isEmpty {
                    if checkedIngredients.isEmpty {
                        return recipes
                    }
                    else {
                        var contained = true
                        let extractedIngredients = RecipeManipulator.extractIngredients(steps: recipe.etapes)
                        let ingredientStrings = RecipeManipulator.getIngredientsString(ingredients: extractedIngredients)
                        for checkedIngredient in checkedIngredients {
                            if !ingredientStrings.contains(checkedIngredient) {
                                contained = false
                            }
                        }
                        if contained {
                            finalResult.append(recipe)
                        }
                    }
                }
                else {
                    if checkedMealTypes.contains(recipe.nomCatRecette) {
                        finalResult.append(recipe)
                    }
                    else {
                        if checkedIngredients.isEmpty {
                            return recipes
                        }
                        else {
                            var contained = true
                            let extractedIngredients = RecipeManipulator.extractIngredients(steps: recipe.etapes)
                            let ingredientStrings = RecipeManipulator.getIngredientsString(ingredients: extractedIngredients)
                            for checkedIngredient in checkedIngredients {
                                if !ingredientStrings.contains(checkedIngredient) {
                                    contained = false
                                }
                            }
                            if contained {
                                finalResult.append(recipe)
                            }
                        }
                    }
                }
            }
            return finalResult
        }
        else {
            //we need to filter using lowercased names
            let filteredBySearchBar = recipes.filter { $0.nomRecette.lowercased().contains(enteredText.lowercased())}
            
            var finalResult : [Recette] = []
            for recipe in filteredBySearchBar {
                if checkedMealTypes.isEmpty {
                    if checkedIngredients.isEmpty {
                        return filteredBySearchBar
                    }
                    else {
                        var contained = true
                        let extractedIngredients = RecipeManipulator.extractIngredients(steps: recipe.etapes)
                        let ingredientStrings = RecipeManipulator.getIngredientsString(ingredients: extractedIngredients)
                        for checkedIngredient in checkedIngredients {
                            if !ingredientStrings.contains(checkedIngredient) {
                                contained = false
                            }
                        }
                        if contained {
                            finalResult.append(recipe)
                        }
                    }
                }
                else {
                    if checkedMealTypes.contains(recipe.nomCatRecette) {
                        finalResult.append(recipe)
                    }
                    else {
                        if checkedIngredients.isEmpty {
                            return recipes
                        }
                        else {
                            var contained = true
                            let extractedIngredients = RecipeManipulator.extractIngredients(steps: recipe.etapes)
                            let ingredientStrings = RecipeManipulator.getIngredientsString(ingredients: extractedIngredients)
                            for checkedIngredient in checkedIngredients {
                                if !ingredientStrings.contains(checkedIngredient) {
                                    contained = false
                                }
                            }
                            if contained {
                                finalResult.append(recipe)
                            }
                        }
                    }
                }
            }
            return finalResult
        }
    }
    
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
                        ingredients.append(["id": ingredient.id,"nomIng": ingredient.nomIng,"nomCat": ingredient.nomCat,"nomCatAllerg": ingredient.nomCatAllerg ?? "","unite":ingredient.unite,"prixUnitaire":ingredient.prixUnitaire,"quantite": ingredientRecette.quantity])
                    }
                    else{
                        ingredients.append(["id": ingredient.id,"nomIng": ingredient.nomIng,"nomCat": ingredient.nomCat,"unite":ingredient.unite,"prixUnitaire":ingredient.prixUnitaire,"quantite": ingredientRecette.quantity])
                        
                    }
                }
                steps.append(["nomEtape": inExtenso.nomEtape ?? "","duree": inExtenso.duree,"description": inExtenso.description,"ingredients":ingredients])
            }
            
            //case Recipe
            if let recipeStep = step as? Recette{
                steps.append(getNSDictionaryFromRecipe(recipe: recipeStep))
            }
        }

        return ["nomRecette":recipe.nomRecette,"nomAuteur": recipe.nomAuteur , "nomCatRecette": recipe.nomCatRecette, "nbCouverts":recipe.nbCouverts,"nomEtape":recipe.nomEtape ?? "", "steps" : steps]
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
                        ingredients.append(["id": ingredient.id,"nomIng": ingredient.nomIng,"nomCat": ingredient.nomCat,"nomCatAllerg": ingredient.nomCatAllerg ?? "","unite":ingredient.unite,"prixUnitaire":ingredient.prixUnitaire,"quantite": ingredientRecette.quantity])
                    }
                    else{
                        ingredients.append(["id": ingredient.id, "nomIng": ingredient.nomIng,"nomCat": ingredient.nomCat,"unite":ingredient.unite,"prixUnitaire":ingredient.prixUnitaire,"quantite": ingredientRecette.quantity])
                        
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
        
        
        firestore.collection("recipes").addDocument(data: ["nomRecette":recipe.nomRecette,"nomAuteur": recipe.nomAuteur , "nomCatRecette": recipe.nomCatRecette, "nbCouverts":recipe.nbCouverts,"nomEtape":recipe.nomEtape ?? "", "steps" : steps]) {
            error in
            if error == nil {
                // no error
            }
        }

    }
    
    
    //removes recipe
    func remove(atOffsets : IndexSet){
        atOffsets.forEach{
            index in
            let recipe = self.recipes[index]
            self.deleteRecipe(recipe: recipe)
        }
    }
    
    func deleteRecipe(recipe: Recette){
        firestore.collection("recipes").document(recipe.id).delete()
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
                        let ingredientModel = Ingredient(id: ingredient["id"] as? String ?? UUID().uuidString, nomIng: ingredient["nomIng"] as? String ?? "", nomCat: ingredient["nomCat"] as? String ?? "", nomCatAllerg: ingredient["nomCatAllerg"] as? String ?? nil, unite: ingredient["unite"] as? String ?? "", prixUnitaire: ingredient["prixUnitaire"] as? Float ?? 0.0, quantite: ingredient["quantite"] as? Double ?? 0.0)
                        return RecipeIngredient(ingredient: ingredientModel, quantity: ingredient["quantite"] as? Double ?? 0.0, id: UUID().uuidString)
                    }
                    else{
                        let ingredientModel = Ingredient(id: ingredient["id"] as? String ?? UUID().uuidString, nomIng: ingredient["nomIng"] as? String ?? "", nomCat: ingredient["nomCat"] as? String ?? "",nomCatAllerg: nil, unite: ingredient["unite"] as? String ?? "", prixUnitaire: ingredient["prixUnitaire"] as? Float ?? 0.0, quantite: ingredient["quantite"] as? Double ?? 0.0)
                        return RecipeIngredient(ingredient: ingredientModel, quantity: ingredient["quantite"] as? Double ?? 0.0, id: UUID().uuidString)
                    }
                    
                }
                
                return InExtensoStep(nomEtape: step["nomEtape"] as? String ?? "", duree: step["duree"] as? Int ?? 0, description: step["description"] as? String ?? "",ingredients:ingredients,id: UUID().uuidString)
            }
            
        }
        return Recette(
            nbCouverts: recipe["nbCouverts"] as? Int ?? 0, nomAuteur: recipe["nomAuteur"] as? String ?? "", nomCatRecette: recipe["nomCatRecette"] as? String ?? "", nomRecette: recipe["nomRecette"] as? String ?? "", etapes: steps, nomEtape: recipe["nomEtape"] as? String ?? "")
    }
    
    //loads recipes
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
                                    let ingredientModel = Ingredient(id: ingredient["id"] as? String ?? UUID().uuidString, nomIng: ingredient["nomIng"] as? String ?? "", nomCat: ingredient["nomCat"] as? String ?? "", nomCatAllerg: ingredient["nomCatAllerg"] as? String ?? "", unite: ingredient["unite"] as? String ?? "", prixUnitaire: ingredient["prixUnitaire"] as? Float ?? 0.0, quantite: ingredient["quantite"] as? Double ?? 0.0)
                                    return RecipeIngredient(ingredient: ingredientModel, quantity: ingredient["quantite"] as? Double ?? 0.0, id: UUID().uuidString)
                                }
                                else{
                                    let ingredientModel = Ingredient(id: ingredient["id"] as? String ?? UUID().uuidString, nomIng: ingredient["nomIng"] as? String ?? "", nomCat: ingredient["nomCat"] as? String ?? "",nomCatAllerg: nil, unite: ingredient["unite"] as? String ?? "", prixUnitaire: ingredient["prixUnitaire"] as? Float ?? 0.0, quantite: ingredient["quantite"] as? Double ?? 0.0)
                                    return RecipeIngredient(ingredient: ingredientModel, quantity: ingredient["quantite"] as? Double ?? 0.0, id: UUID().uuidString)
                                }
                                
                            }
                            
                            return InExtensoStep(nomEtape: step["nomEtape"] as? String ?? "", duree: step["duree"] as? Int ?? 0, description: step["description"] as? String ?? "",ingredients: ingredients,id: UUID().uuidString)
                        }
                        
                    }
                    return Recette(
                        nbCouverts: doc["nbCouverts"] as? Int ?? 0, nomAuteur: doc["nomAuteur"] as? String ?? "", nomCatRecette: doc["nomCatRecette"] as? String ?? "", nomRecette: doc["nomRecette"] as? String ?? "", etapes: steps,nomEtape: doc["nomEtape"] as? String ?? "",id: doc.documentID)
                }
            }
    }
    
    //load ingredients for the filter by ingredients
    func loadIngredients() {
        firestore.collection("ingredients")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                self.filters = []
                for document in documents {
                    let title = document["nomIng"] as? String ?? ""
                    if !self.filters.contains(where: {$0.title == title}) {
                        self.filters.append(FilterItem(title: title))
                    }
                }
                self.ingredientFilters = Filter(filters: self.filters)
            }
    }
}



