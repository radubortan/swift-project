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


    init(){
        Task{
            loadStocks()
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
    
    
    @Published var filteringOptions = IngredientFilteringOptions()
    
    @Published var ingredientsFiltered : [Ingredient] = []

    
    
    func filterIngredient(ingredient : Ingredient) -> Bool{
        if(filteringOptions.patternToMatch != "" && !ingredient.nomIng.lowercased().contains(filteringOptions.patternToMatch.lowercased())){
            return false
        }
        if (filteringOptions.categories.count != 0 && !filteringOptions.categories.contains(ingredient.nomCat)) {
              return false;
            }
            if (
                filteringOptions.allergens.count != 0
            ) {
                if let allergen = ingredient.nomCatAllerg {
                    if(!filteringOptions.allergens.contains(allergen)){
                        return false
                    }
                    else {
                        return true
                    }
                }
                else {
                    return false
                }
            }
            return true;
    }
    func filterIngredients() {
        let filteredList = stocks.filter(filterIngredient);
        self.ingredientsFiltered = filteredList
     };
    
    
    
    
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
                                      quantite: doc["quantite"] as? Int ?? 0)
                }
            }
    }
    
}
