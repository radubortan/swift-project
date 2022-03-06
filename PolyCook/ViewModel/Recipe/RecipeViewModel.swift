//
//  RecipeViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 06/03/2022.
//

import Foundation
import SwiftUI

class RecipeViewModel: ObservableObject {
    //sheet states
    @Published var costsSheetIsOn = false
    @Published var ingredientsSheetIsOn = false
    @Published var showStep = false
    @Published var showPdf = false
    
    //pdf states
    @Published var showCosts = false
    @Published var quantity = 1
    
    //recipe information
    @Published var isSheet : Bool
    @Published var recette : Recette
    
    init(recipe: Recette, isSheet: Bool) {
        self.recette = recipe
        self.isSheet = isSheet
    }
}
