import Foundation
import SwiftUI

class PdfViewModel : ObservableObject {
    @Published var PDFUrl : URL?
    @Published var showShareSheet: Bool = false
    
    var showCosts : Binding<Bool>
    var quantity: Binding<Int>
    @ObservedObject var costsInfo : CostsInfo
    
    let recipe : Recette
    
    init(costsInfo: CostsInfo, showCosts : Binding<Bool>, quantity: Binding<Int>, recipe : Recette) {
        self.costsInfo = costsInfo
        self.showCosts = showCosts
        self.quantity = quantity
        self.recipe = recipe
    }
    
    var steps : [InExtensoStep] {
        let copiedRecipe = RecipeManipulator.copyRecipe(recipe: self.recipe)
        let steps = RecipeManipulator.extractSteps(steps: copiedRecipe.etapes)
        RecipeManipulator.multiplyIngredients(steps: steps, multiplier: quantity.wrappedValue)
        return steps
    }
}
