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
    
    let nbCouverts : Int
    
    let numberFormatter : NumberFormatter
    
    var coutMatiere : Double {
        if costsInfo.customAssaisonnement {
            return self.totalIngredientsValue + costsInfo.customAssaissonnementValue
        }
        else {
            return self.totalIngredientsValue * 1.05
        }
    }
    
    var coutPersonnel : Double {
        if costsInfo.customParams{
            return Double(fetchTotalDuration()) * self.costsInfo.customCoutHoraireMoyen

        }else{
            return Double(fetchTotalDuration()) * self.costsInfo.coutHoraireMoyen

        }
    }
    
    var coutFluide : Double {
        if costsInfo.customParams {
            return Double(fetchTotalDuration()) * self.costsInfo.customCoutHoraireForfaitaire
        }
        else{
            return Double(fetchTotalDuration()) * self.costsInfo.coutHoraireForfaitaire

        }
    }
    
    var coutCharges : Double {
        if costsInfo.withCharges{
            return coutPersonnel + coutFluide
        }else{
            return 0
        }
    }
    
    var coutProduction : Double {
        return self.coutMatiere + self.coutCharges
    }
    
    var coutVente : Double {
        
        if costsInfo.withCharges{
            if costsInfo.customParams {
                return self.coutProduction * self.costsInfo.customCoeffMultiAvec

            }
            else{
                return self.coutProduction * self.costsInfo.coeffMultiAvec
            }
        }
        else{
            if costsInfo.customParams {
                return self.coutProduction * self.costsInfo.customCoeffMultiSans
            }
            else{
                return self.coutProduction * self.costsInfo.coeffMultiSans
            }
        }
    }
    
    var coutVenteParPortion : Double {
        return coutVente / Double(self.nbCouverts)
    }
    
     var coutHoraireMoyen : Double {
         if costsInfo.customParams {
             return costsInfo.customCoutHoraireMoyen
         }
         else {
             return costsInfo.coutHoraireMoyen
         }
     }
     var coutHoraireForfaitaire : Double {
         if costsInfo.customParams {
             return costsInfo.customCoutHoraireForfaitaire
         }
         else{
             return costsInfo.coutHoraireForfaitaire
         }
     }
    
    @Published var totalIngredientsValue : Double = 0
    
    func fetchTotalDuration() -> Int{
        let steps = RecipeManipulator.extractSteps(steps: self.steps)
        var totalDuration = 0
        for step in steps {
            totalDuration += step.duree
        }
        return totalDuration
    }
    
    func fetchTotalIngredientsValue() async {
        let ingredients = RecipeManipulator.extractIngredients(steps: self.steps)
        
        for ingredient in ingredients {
            ingredient.ingredient.prixUnitaire = await fetchPrixUnitaire(ingredient: ingredient)
            
        }
        
        for ingredient in ingredients {
            DispatchQueue.main .async {
                self.totalIngredientsValue += ingredient.quantity * Double(ingredient.ingredient.prixUnitaire)
            }
        }
        
    }
    
    func fetchPrixUnitaire(ingredient: RecipeIngredient) async -> Float {
        var prixUnitaire : Float = 0
        do{
            let snapshot = try await firestore.collection("ingredients").document(ingredient.ingredient.id).getDocument()
            prixUnitaire = snapshot.data()?["prixUnitaire"] as? Float ?? 0
        }
        catch{
            print("error")
        }
        return prixUnitaire
    }
    
    init(costsInfo: CostsInfo, steps : [Step], nbCouverts : Int) {
        self.costsInfo = costsInfo
        self.steps = steps
        self.nbCouverts = nbCouverts
        
        numberFormatter = NumberFormatter()
        //to format into decimal numbers
        numberFormatter.numberStyle = .decimal
    }
}
