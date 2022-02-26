//
//  RecipeListViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 26/02/2022.
//

import Foundation
import Combine

class RecipeListViewModel : ObservableObject, Subscriber {
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
}
