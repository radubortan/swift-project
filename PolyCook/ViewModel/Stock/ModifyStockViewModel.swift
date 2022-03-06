//
//  ModifyStockViewModel.swift
//  PolyCook
//
//  Created by Tupac Rocher on 03/03/2022.
//

import Foundation
import Combine

class ModifyStockViewModel: ObservableObject{

    private(set) var ingredient : Ingredient
    
    //formats the entered values
    let numberFormatter : NumberFormatter
    
    @Published var nomIng: String
    @Published var nomCat: String
    @Published var nomCatAllerg: String?
    @Published var unite: String
    @Published var prixUnitaire: Float
    @Published var quantite: Double
    
    @Published var quantityToAdd: Double
    @Published var quantityToRemove: Double
    @Published var totalPriceOfAddedQuantity : Float
    
    @Published var isAdding : Bool = false
    @Published var increase : Double = 0
    @Published var decrease : Double = 0
    @Published var price : Double = 0
    
    init(ingredient: Ingredient){
        self.ingredient = ingredient
        self.nomIng = ingredient.nomIng
        self.nomCat = ingredient.nomCat
        self.nomCatAllerg = ingredient.nomCatAllerg
        self.unite = ingredient.unite
        self.prixUnitaire = ingredient.prixUnitaire
        self.quantite = ingredient.quantite
        
        self.quantityToAdd = 0
        self.quantityToRemove = 0
        self.totalPriceOfAddedQuantity = 0.0
        
        numberFormatter = NumberFormatter()
        //to format into decimal numbers
        numberFormatter.numberStyle = .decimal
    }
    
    
}
