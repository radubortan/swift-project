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

    init(){
        Task{
            loadIngredients()
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
        let filteredList = ingredients.filter(filterIngredient);
        self.ingredientsFiltered = filteredList
     };
    
    
    func remove(atOffsets : IndexSet){
        atOffsets.forEach{
            index in
            let ingredient = self.ingredients[index]
            self.deleteIngredient(ingredient: ingredient)
        }
//        self.ingredients.remove(atOffsets: atOffsets)

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
                self.ingredientsFiltered = documents.map{
                    (doc) -> Ingredient in
                    return Ingredient(id: doc.documentID,
                                      nomIng: doc["nomIng"] as? String ?? "",
                                      nomCat: doc["nomCat"] as? String ?? "",
                                      nomCatAllerg: doc["nomCatAllerg"] as? String ?? nil,
                                      unite: doc["unite"] as? String ?? "",prixUnitaire: doc["prixUnitaire"] as? Float ?? 0 )
                }
            }
    }
    
}
