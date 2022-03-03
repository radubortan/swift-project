//
//  IngredientViewModel.swift
//  PolyCook
//
//  Created by Tupac Rocher on 22/02/2022.
//

import Foundation
import Combine

class IngredientViewModel: ObservableObject, IngredientObserver, Subscriber{

    private(set) var ingredient : Ingredient
    
    @Published var nomIng: String
    @Published var nomCat: String
    @Published var nomCatAllerg: String?
    @Published var unite: String
    @Published var prixUnitaire: Float
    
    init(ingredient: Ingredient){
        self.ingredient = ingredient
        self.nomIng = ingredient.nomIng
        self.nomCat = ingredient.nomCat
        self.nomCatAllerg = ingredient.nomCatAllerg
        self.unite = ingredient.unite
        self.prixUnitaire = ingredient.prixUnitaire
        self.ingredient.add(ingredientObserver: self)
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
        case .addIngredient(_):
            break
        case .updatingIngredientList:
            break
        case .nomIngChanging(let nomIng):
            print("vm: change model ingredient name to '\(nomIng)'")
            self.ingredient.nomIng = nomIng
            if nomIng != self.ingredient.nomIng {
//                self.error = .trackNameError(trackName)
                self.nomIng = self.ingredient.nomIng
            }
            print("vm: model ingredient name changed to '\(self.ingredient.nomIng)'")
            self.ingredient.nomIng = nomIng
            break
        case .nomIngChanged(_):
            break
        case .nomIngError(_):
            break
        case .nomCatChanging(let nomCat):
            self.ingredient.nomCat = nomCat
            break
        case .nomCatAllergChanging(let nomCatAllerg):
            self.ingredient.nomCatAllerg = nomCatAllerg
            break
        case .editIngredient(_):
            break
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    func changed(nomIng: String) {
        print("vm observer: nomIng changed => self.nomIng = '\(nomIng)'")
        self.nomIng = nomIng
    }
    
    func changed(nomCat: String) {
        self.nomCat = nomCat
    }
    
    func changed(nomCatAllerg: String?) {
        self.nomCatAllerg = nomCatAllerg
    }
    
}
