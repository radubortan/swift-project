//
//  RecipeViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 06/03/2022.
//

import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    @Published var costsSheetIsOn = false
    @Published var ingredientsSheetIsOn = false
    @Published var showCosts = false
    @Published var quantity = 1
    @Published var showStep = false
    @Published var showPdf = false
    @Published var isSheet : Bool
    @Published var recette : Recette
    
    init(recipe: Recette, isSheet: Bool) {
        self.recette = recipe
        self.isSheet = isSheet
    }
}
