//
//  CostsViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 06/03/2022.
//

import Foundation
import SwiftUI
import FirebaseFirestore

class CostsViewModel : ObservableObject {
    @ObservedObject var costsInfo : CostsInfo
    private let firestore = Firestore.firestore()
    
    let steps : [Step]
    
    let numberFormatter : NumberFormatter
    
    var coutMatiere : Double {
        if costsInfo.customAssaisonnement {
            return self.totalIngredientsValue + costsInfo.customAssaissonnementValue
        }
        else {
            return self.totalIngredientsValue * 1.05
        }
    }
    
    var totalIngredientsValue : Double {
        let ingredients = RecipeManipulator.extractIngredients(steps: self.steps)
        var totalValue : Double = 0
        
        for ingredient in ingredients {
            print("prix unitaire est \(fetchPrixUnitaire(id: ingredient.ingredient.id))")
            print("For ingredient \(ingredient.ingredient.nomIng), the quantity is \(ingredient.quantity) with a value of \(ingredient.ingredient.prixUnitaire)")
            totalValue += ingredient.quantity * Double(ingredient.ingredient.prixUnitaire)
        }
        return totalValue
    }
    
    init(costsInfo: CostsInfo, steps : [Step]) {
        self.costsInfo = costsInfo
        self.steps = steps
        
        numberFormatter = NumberFormatter()
        //to format into decimal numbers
        numberFormatter.numberStyle = .decimal
        print(totalIngredientsValue)
    }
    
    func fetchPrixUnitaire(id: String) -> Double {
        print("le id est \(id)")
        var result : Double = 0
        firestore.collection("ingredients").document(id).getDocument { (document, error) in
            if let document = document, document.exists {
                let docData = document.data()
                result = docData!["prixUnitaire"] as? Double ?? 0
            }
        }
        return result
    }
}
