//
//  NewStepViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 27/02/2022.
//

import Foundation

class NewStepViewModel : ObservableObject {
    
    var listIntent : CreateRecipeIntent
    
    @Published var isRecipe = false
    @Published var nomEtape = ""
    @Published var duration = 1
    @Published var description = ""
    @Published var ingredient = "Poisson"
    @Published var recipe = "Sauce tomate"
    @Published var quantity = 1
    @Published var subrecipeQuantity = 1
    @Published var ingredients = ["Pomme", "Tomate"]
    
    //formats the entered values
    let numberFormatter = NumberFormatter()
    
    func deletion(at indexSet: IndexSet) {
        
    }
    
    init(listVm: CreateRecipeViewModel) {
        self.listIntent = CreateRecipeIntent()
        self.listIntent.addObserver(viewModel: listVm)
    }
}
