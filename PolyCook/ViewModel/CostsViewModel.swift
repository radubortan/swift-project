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
    
    var totalIngredientsValue : Double = 0
    
//    func fetchTotalIngredientsValue() async {
//        let ingredients = RecipeManipulator.extractIngredients(steps: self.steps)
//        var totalValue : Double = 0
//
//        for ingredient in ingredients {
//            let prix = await fetchPrixUnitaire(id: ingredient.ingredient.id)
//            totalValue += ingredient.quantity * prix
//        }
//
//        self.totalIngredientsValue = totalValue
//    }
    
    func fetchTotalIngredientsValue() async {
        let ingredients = RecipeManipulator.extractIngredients(steps: self.steps)
        var totalValue : Double = 0
        
        await fetchPrixUnitaire(ingredients : ingredients)
        
        for ingredient in ingredients {
            print("apres fonction \(ingredient.ingredient.prixUnitaire)")
            totalValue += ingredient.quantity * Double(ingredient.ingredient.prixUnitaire)
        }
        
        self.totalIngredientsValue = totalValue
    }
    
    func fetchPrixUnitaire(ingredients: [RecipeIngredient]) async {
        for ingredient in ingredients {
            firestore.collection("ingredients").document(ingredient.ingredient.id).getDocument { (document, error) in
                if let document = document, document.exists {
                    let docData = document.data()
                    ingredient.ingredient.prixUnitaire = Float(docData!["prixUnitaire"] as? Double ?? 0)
                    print("\(ingredient.ingredient.prixUnitaire)")
                }
            }
        }
    }
    
//    func fetchPrixUnitaire(id: String) async -> Double {
//        var result : Double = 2
//        //il faut attendre que cette requete soit finie
//        firestore.collection("ingredients").document(id).getDocument { (document, error) in
//            if let document = document, document.exists {
//                let docData = document.data()
//                result = docData!["prixUnitaire"] as? Double ?? 0
//            }
//        }
//        //une fois la requete finie, retourner le résultat
//        return result
//    }
    
    init(costsInfo: CostsInfo, steps : [Step]) {
        self.costsInfo = costsInfo
        self.steps = steps
        
        numberFormatter = NumberFormatter()
        //to format into decimal numbers
        numberFormatter.numberStyle = .decimal
        
        Task {
            await fetchTotalIngredientsValue()
        }
    }
}
