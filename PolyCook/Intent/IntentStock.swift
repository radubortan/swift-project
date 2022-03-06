//
//  IntentStock.swift
//  PolyCook
//
//  Created by Tupac Rocher on 03/03/2022.
//

import Foundation
import Combine


enum StockError: Error, CustomStringConvertible, Equatable{
   case tooShortName(String)
   case unknown
   var  description: String{
      switch self{
         case .tooShortName(let name): return "name must be at least 3 characters length: \(name)"
         default: return "unknown error on ingredient name"
      }
   }
}

enum IntentStockState : Equatable {
    case ready
    case stockDecreasing(Double)
    case stockIncreasing(Double,Float)
    case editIngredient(Ingredient)
    case updatingStockList
}

struct IntentStock {
    private var state = PassthroughSubject<IntentStockState, Never>()
    
    func viewUpdated(){
        self.state.send(.ready)
    }
    
    func addObserver(viewModel: StockListViewModel){
        self.state.subscribe(viewModel)
    }
    func addObserver(viewModel: StockViewModel){
        self.state.subscribe(viewModel)
    }
    
    func intentToEditIngredient(ingredient: Ingredient){
        self.state.send(.editIngredient(ingredient))
        self.state.send(.updatingStockList)
    }
    
    func intentToIncreaseStock(quantityToBeAdded: Double, totalPriceOfQuantityAdded: Float){
        self.state.send(.stockIncreasing(quantityToBeAdded, totalPriceOfQuantityAdded))
        self.state.send(.updatingStockList)
    }
    func intentToDecreaseStock(quantityToBeRemoved: Double){
        
            self.state.send(.stockDecreasing(quantityToBeRemoved))
            self.state.send(.updatingStockList)
    }
}

