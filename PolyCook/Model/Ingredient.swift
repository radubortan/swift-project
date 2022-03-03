//
//  Ingredient.swift
//  PolyCook
//
//  Created by Tupac Rocher on 22/02/2022.
//

import Foundation

protocol IngredientObserver: AnyObject {
    func changed(nomIng: String)
    func changed(nomCat: String)
    func changed(nomCatAllerg: String?)
}

class Ingredient: ObservableObject, Identifiable, Equatable {
    static func == (lhs: Ingredient, rhs: Ingredient) -> Bool {
        return lhs === rhs
    }
    
    
    var ingredientObserver: IngredientObserver?
    
    var id : String = UUID().uuidString
    var nomIng : String{
        didSet {
            guard nomIng != oldValue else { return }
            for ingredientObserver in ingredientObservers{ ingredientObserver.changed(nomIng: nomIng) }
        }
    }
    var nomCat : String{
        didSet {
            self.ingredientObserver?.changed(nomCat: self.nomCat)
        }
    }
    var nomCatAllerg : String?{
        didSet {
            self.ingredientObserver?.changed(nomCatAllerg: self.nomCatAllerg)
        }
    }
    var unite : String
    
    var prixUnitaire : Float
    
    var quantite : Int
    
    init(id: String,nomIng: String,nomCat: String, nomCatAllerg: String?, unite: String, prixUnitaire : Float = 0.0, quantite: Int = 0){
        self.id = id
        self.nomIng = nomIng
        self.nomCat = nomCat
        self.nomCatAllerg = nomCatAllerg
        self.unite = unite
        self.prixUnitaire = prixUnitaire
        self.quantite = quantite
    }
    
    //OBSERVERS
    
    private var ingredientObservers = [IngredientObserver]()
    
    func add(ingredientObserver: IngredientObserver) {
       self.ingredientObservers.append(ingredientObserver)
       print("add delegate : \(self.ingredientObservers.count) delagates now")
    }
    
    func remove(ingredientObserver: IngredientObserver) {
       self.ingredientObservers.removeAll{ $0 === ingredientObserver}
    }

    func nomIngChanged(nomIng: String){
       for ingredientObserver in ingredientObservers{ ingredientObserver.changed(nomIng: nomIng) }
    }
}
