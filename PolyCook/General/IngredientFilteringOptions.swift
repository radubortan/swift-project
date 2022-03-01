//
//  FilteringOptionsIngredient.swift
//  PolyCook
//
//  Created by Tupac Rocher on 28/02/2022.
//

import Foundation

class IngredientFilteringOptions : ObservableObject {
    var patternToMatch : String = ""
    var categories : [String] = []
    var allergens : [String] = []
}
