//
//  TicketViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 07/03/2022.
//

import Foundation
import SwiftUI

class TicketViewModel: ObservableObject {
    let recipe : Recette
    
    @Published var PDFUrl : URL?
    @Published var showShareSheet: Bool = false
    
    init(recipe: Recette) {
        self.recipe = recipe
    }
    
    var ingredients : [RecipeIngredient] {
        return RecipeManipulator.extractIngredients(steps: self.recipe.etapes)
    }
}
