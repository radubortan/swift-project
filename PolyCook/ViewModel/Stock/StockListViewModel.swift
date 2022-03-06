//
//  IngredientDTOListViewModel.swift
//  PolyCook
//
//  Created by Tupac Rocher on 03/03/2022.
//

import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class StockListViewModel : ObservableObject, Subscriber{
    private let firestore  = Firestore.firestore()

    @Published private(set) var stocks = [Ingredient]()
    
    @Published var enteredText : String = ""
    
    //filter states
    @Published var showCategoryFilter = false
    @Published var showAllergenFilter = false
    
    @Published var showingSheet = false
    
    //filters
    @Published var categoryFilters : Filter = Filter(filters: [])
    @Published var allergenFilters : Filter = Filter(filters: [])
    
    init(){
        Task{
            loadStocks()
            loadCategories()
            loadAllergens()
        }
    }
    
    typealias Input = IntentStockState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IntentStockState) -> Subscribers.Demand {
        switch input{
        case .ready:
            break
        case .stockIncreasing(_, _):
            break
        case .stockDecreasing(_):
            break
        case .editIngredient(let ingredient):
            self.editIngredient(ingredient: ingredient)
            break
        case .updatingStockList:
            self.objectWillChange.send()
            break
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    
    //ingredients being shown
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
            filteredByCategory = stocks.filter { ingredient in
                return checkedCategories.contains(ingredient.nomCat) || checkedCategories.isEmpty
            }
        }
        else {
            //filter by search bar
            let filteredBySearchBar = stocks.filter { $0.nomIng.lowercased().contains(enteredText.lowercased())}
            
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
    
    
    func editIngredient(ingredient: Ingredient){
        firestore.collection("ingredients").document(ingredient.id).setData(["quantite":ingredient.quantite, "prixUnitaire": ingredient.prixUnitaire],merge: true) {
                error in
                if error == nil {
                    // no error
                }
            }
    }
    
    func loadStocks() {
        firestore.collection("ingredients")
            .addSnapshotListener{
                 (data, error) in
                guard let documents = data?.documents else {
                   return
                }
                self.stocks = documents.map{
                    (doc) -> Ingredient in
                    return Ingredient(id: doc.documentID,
                                      nomIng: doc["nomIng"] as? String ?? "",
                                      nomCat: doc["nomCat"] as? String ?? "",
                                      nomCatAllerg: doc["nomCatAllerg"] as? String ?? nil,
                                      unite: doc["unite"] as? String ?? "",
                                      prixUnitaire: doc["prixUnitaire"] as? Float ?? 0.0,
                                      quantite: doc["quantite"] as? Double ?? 0)
                }
                self.stocks.sort(by: {$0.nomIng < $1.nomIng})
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
                tempCategoryFilters.sort(by: {$0.title < $1.title})
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
                tempAllergenFilters.sort(by: {$0.title < $1.title})
                self.allergenFilters = Filter(filters: tempAllergenFilters)
            }
    }
    
}
