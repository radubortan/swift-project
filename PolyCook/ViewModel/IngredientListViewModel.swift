//
//  IngredientDTOListViewModel.swift
//  PolyCook
//
//  Created by Tupac Rocher on 22/02/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class IngredientListViewModel : ObservableObject, Subscriber{
    
    private let firestore  = Firestore.firestore()

    @Published private(set) var ingredients = [Ingredient]()
    
    @Published var enteredText : String = ""
    
    @Published var toBeDeleted : IndexSet?
    @Published var showingDeleteAlert = false
    
    //show filter states
    @Published var showCategoryFilter = false
    @Published var showAllergenFilter = false
    
    @Published var showingCreationSheet = false
    @Published var showingInfoSheet = false
    
    //filters
    @Published var categoryFilters : Filter = Filter(filters: [])
    @Published var allergenFilters : Filter = Filter(filters: [])
    
    init(){
        Task{
            loadIngredients()
            loadCategories()
            loadAllergens()
        }
    }
    
    typealias Input = IntentIngredientState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IntentIngredientState) -> Subscribers.Demand {
        switch input{
        case .ready:
            break
        case .addIngredient(let ingredient):
            ingredients.append(_:ingredient)
            self.addIngredient(ingredient: ingredient)
            break
        case .updatingIngredientList:
            self.objectWillChange.send()
            break
        case .nomIngChanging(_):
            break
        case .nomIngChanged(_):
            break
        case .nomIngError(_):
            break
        case .nomCatChanging(_):
            break
        case .nomCatAllergChanging(_):
            break
        case .editIngredient(let ingredient):
            self.editIngredient(ingredient: ingredient)
            break
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    var filterResults : [Ingredient] {
        //extracting the selected categories
        var checkedCategories : [String] = []
        for filter in categoryFilters.filters {
            if filter.checked {
                checkedCategories.append(filter.title)
            }
        }
        
        //extracting the selected allergens
        var checkedAllergens : [String] = []
        for filter in allergenFilters.filters {
            if filter.checked {
                checkedAllergens.append(filter.title)
            }
        }
        
        var filteredByCategory : [Ingredient]
        
        //checking if text has been entered in the search bar
        if enteredText.isEmpty {
            //filter by category
            filteredByCategory = ingredients.filter { ingredient in
                return checkedCategories.contains(ingredient.nomCat) || checkedCategories.isEmpty
            }
        }
        else {
            //filter by search bar
            let filteredBySearchBar = ingredients.filter { $0.nomIng.lowercased().contains(enteredText.lowercased())}
            
            //then filter by category
            filteredByCategory = filteredBySearchBar.filter { ingredient in
                return checkedCategories.contains(ingredient.nomCat) || checkedCategories.isEmpty
            }
        }
        
        let filteredByAllergen = filteredByCategory.filter { ingredient in
            if checkedAllergens.isEmpty {
                //no selection so we keep everything
                return true
            }
            if let catAllergen = ingredient.nomCatAllerg {
                return checkedAllergens.contains(catAllergen)
            }
            else {
                //we have selected an allergen and current ingredient isn't allergenic, so it's removed
                return false
            }
        }

        return filteredByAllergen
    }
    
    func remove(atOffsets : IndexSet){
        atOffsets.forEach{
            index in
            let ingredient = self.ingredients[index]
            self.deleteIngredient(ingredient: ingredient)
        }
    }
    
    func deleteIngredient(ingredient: Ingredient){
        firestore.collection("ingredients").document(ingredient.id).delete()
    }
    
    func editIngredient(ingredient: Ingredient){
        if let allergenCategory = ingredient.nomCatAllerg {
            firestore.collection("ingredients").document(ingredient.id).setData(["nomIng":ingredient.nomIng,"nomCat": ingredient.nomCat , "nomCatAllerg": allergenCategory, "unite":ingredient.unite,"quantite":ingredient.quantite, "prixUnitaire": ingredient.prixUnitaire]) {
                error in
                if error == nil {
                    // no error
                }
            }
        }
        else {
            firestore.collection("ingredients").document(ingredient.id).setData(["nomIng":ingredient.nomIng,"nomCat": ingredient.nomCat ,"unite":ingredient.unite,"quantite":ingredient.quantite, "prixUnitaire": ingredient.prixUnitaire]) {
                error in
                if error == nil {
                    // no error
                }
            }
        }

    }
    
    func addIngredient(ingredient: Ingredient){
        if let allergenCategory = ingredient.nomCatAllerg {
            firestore.collection("ingredients").addDocument(data: ["nomIng":ingredient.nomIng,"nomCat": ingredient.nomCat , "nomCatAllerg": allergenCategory, "unite":ingredient.unite, "prixUnitaire" : ingredient.prixUnitaire, "quantite" : ingredient.quantite]) {
                error in
                if error == nil {
                    // no error
                }
            }
        }
        else {
            firestore.collection("ingredients").addDocument(data: ["nomIng":ingredient.nomIng,"nomCat": ingredient.nomCat , "unite":ingredient.unite,"prixUnitaire" : ingredient.prixUnitaire, "quantite" : ingredient.quantite])
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
                    return Ingredient(id: doc.documentID,
                                      nomIng: doc["nomIng"] as? String ?? "",
                                      nomCat: doc["nomCat"] as? String ?? "",
                                      nomCatAllerg: doc["nomCatAllerg"] as? String ?? nil,
                                      unite: doc["unite"] as? String ?? "",prixUnitaire: doc["prixUnitaire"] as? Float ?? 0)
                }
            }
    }
    
    
    //load recipe categories for category filter
    func loadCategories() {
        firestore.collection("categoriesIngredients")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                var tempCategoryFilters : [FilterItem] = []
                for document in documents {
                    let title = document["nomCatIng"] as? String ?? ""
                    tempCategoryFilters.append(FilterItem(title: title))
                }
                self.categoryFilters = Filter(filters: tempCategoryFilters)
            }
    }
    
    
    //loads allergens for allergen filter
    func loadAllergens() {
        firestore.collection("allergenes")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                var tempAllergenFilters : [FilterItem] = []
                for document in documents {
                    let title = document["nomCatAllerg"] as? String ?? ""
                    tempAllergenFilters.append(FilterItem(title: title))
                }
                self.allergenFilters = Filter(filters: tempAllergenFilters)
            }
    }
    
}
