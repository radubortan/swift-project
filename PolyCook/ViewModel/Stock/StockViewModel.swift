//
//  StockViewModel.swift
//  PolyCook
//
//  Created by Tupac Rocher on 03/03/2022.
//

import Foundation
import Combine
import SwiftUI

class StockViewModel: ObservableObject, IngredientObserver, Subscriber{

    private(set) var ingredient : Ingredient
    
    //text sizes
    let bigText = CGFloat(25)
    let smallText = CGFloat(20)
    
    @Published var nomIng: String
    @Published var nomCat: String
    @Published var nomCatAllerg: String?
    @Published var unite: String
    @Published var prixUnitaire: Float
    @Published var quantite: Double
    @Published var showingSheet = false
    
    init(ingredient: Ingredient){
        self.ingredient = ingredient
        self.nomIng = ingredient.nomIng
        self.nomCat = ingredient.nomCat
        self.nomCatAllerg = ingredient.nomCatAllerg
        self.unite = ingredient.unite
        self.prixUnitaire = ingredient.prixUnitaire
        self.quantite = ingredient.quantite
        self.ingredient.add(ingredientObserver: self)
    }
    
    //intent
    typealias Input = IntentStockState
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: IntentStockState) -> Subscribers.Demand {
        switch input{
        case .ready:
            break
        case .updatingStockList:
            break
        case.stockIncreasing(let quantityToBeAdded, let buyingPrice):
            let newQuantity = self.ingredient.quantite + quantityToBeAdded
            let newPrice = (self.ingredient.prixUnitaire * Float(self.ingredient.quantite) + buyingPrice)/Float(newQuantity)
            
            
            self.ingredient.quantite = newQuantity

            if newQuantity != self.ingredient.quantite {
                self.quantite = self.ingredient.quantite
            }
            
            self.ingredient.prixUnitaire = newPrice
            if newPrice != self.ingredient.prixUnitaire {
                self.prixUnitaire = self.ingredient.prixUnitaire
            }
            break
        case .stockDecreasing(let quantityToBeRemoved):
            let newQuantity = self.ingredient.quantite - quantityToBeRemoved
            
            if newQuantity <= 0{
                self.ingredient.quantite = 0
                if newQuantity != self.ingredient.quantite {
                    self.quantite = self.ingredient.quantite
                }
                self.ingredient.prixUnitaire = 0.0
                if newQuantity != self.ingredient.quantite {
                    self.quantite = self.ingredient.quantite
                }
            }else{
                self.ingredient.quantite = newQuantity
                if newQuantity != self.ingredient.quantite {
                    self.quantite = self.ingredient.quantite
                }
            }
            
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
        self.nomIng = nomIng
    }
    
    func changed(nomCat: String) {
        self.nomCat = nomCat
    }
    
    func changed(nomCatAllerg: String?) {
        self.nomCatAllerg = nomCatAllerg
    }
    
}

