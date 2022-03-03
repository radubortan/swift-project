//
//  InExtensoStep.swift
//  PolyCook
//
//  Created by Radu Bortan on 27/02/2022.
//

import Foundation

class Step {
    var id : String
    var nomEtape : String
    
    init(id: String, nomEtape: String) {
        self.id = id
        self.nomEtape = nomEtape
    }
}

class InExtensoStep : Step {
    var duree : Int
    var description : String
    var ingredients : [RecipeIngredient]
    
    init(nomEtape: String, duree: Int, description: String, ingredients : [RecipeIngredient], id: String = UUID().uuidString) {
        self.duree = duree
        self.description = description
        self.ingredients = ingredients
        super.init(id: id, nomEtape: nomEtape)
    }
}
