//
//  AddIngredientViewModel.swift
//  PolyCook
//
//  Created by Tupac Rocher on 27/02/2022.
//

import Foundation
import Combine

class AddIngredientViewModel: ObservableObject,IngredientObserver {
    
    @Published var nomIngIsTooShort : Bool
    
    @Published var intentIngredientState : IntentIngredientState = .ready {
        didSet{
            switch self.intentIngredientState{
            case .ready:
                break
            case .nomIngChanging(let nomIng):
                nomIngIsTooShort = false
                self.ingredient.nomIng = nomIng
                break
            case .nomIngChanged(_):
                break
            case .nomIngError(_):
                nomIngIsTooShort = true
                break
            case .nomCatChanging(_):
                break
            case .nomCatAllergChanging(_):
                break
            case .addIngredient(_):
                break
            case .updatingIngredientList:
                break
            case .editIngredient(_):
                break
            }
        }
    }
    
    private(set) var ingredient : Ingredient
    
    @Published var nomIng: String
    
    @Published var nomCat: String {
        didSet {
            self.ingredient.nomCat = self.nomCat
        }
    }
    @Published var nomCatAllerg: String? {
        didSet {
            self.ingredient.nomCatAllerg = self.nomCatAllerg
        }
    }
    @Published var unite: String {
        didSet {
            self.ingredient.unite = self.unite
        }
    }
    
    init(ingredient: Ingredient){
        self.nomIngIsTooShort = false
        self.ingredient = ingredient
        self.nomIng = ingredient.nomIng
        self.nomCat = ingredient.nomCat
        self.nomCatAllerg = ingredient.nomCatAllerg
        self.unite = ingredient.unite
        self.ingredient.add(ingredientObserver: self)
    }
    
    func changed(nomIng: String) {
        self.nomIng = nomIng
        print("vm observer: nomIng changed => self.nomIng = '\(nomIng)'")
        self.intentIngredientState = .nomIngChanged(nomIng)
    }
    
    func changed(nomCat: String) {
        self.nomCat = nomCat
    }
    
    func changed(nomCatAllerg: String?) {
        self.nomCatAllerg = nomCatAllerg
    }
    
}
