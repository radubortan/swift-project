import Foundation
import SwiftUI
import FirebaseFirestore

class PdfViewModel : ObservableObject {
    @Published var PDFUrl : URL?
    @Published var showShareSheet: Bool = false
    
    var showCosts : Binding<Bool>
    var quantity: Binding<Int>
    @ObservedObject var costsInfo : CostsInfo
    
    private let firestore = Firestore.firestore()
    
    let recipe : Recette
    
    @Published var totalIngredientsValue : Double = 0

    
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
        return coutVente / Double(self.recipe.nbCouverts)
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
    
    init(costsInfo: CostsInfo, showCosts : Binding<Bool>, quantity: Binding<Int>, recipe : Recette) {
        self.costsInfo = costsInfo
        self.showCosts = showCosts
        self.quantity = quantity
        self.recipe = recipe
        Task{
            await fetchTotalIngredientsValue()
        }
    }
    
    var steps : [InExtensoStep] {
        let copiedRecipe = RecipeManipulator.copyRecipe(recipe: self.recipe)
        let steps = RecipeManipulator.extractSteps(steps: copiedRecipe.etapes)
        RecipeManipulator.multiplyIngredients(steps: steps, multiplier: quantity.wrappedValue)
        return steps
    }
    
    func fetchTotalDuration() -> Int{
        let steps = RecipeManipulator.extractSteps(steps: self.recipe.etapes)
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
    
    
}
