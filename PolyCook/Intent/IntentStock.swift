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
    case stockDecreasing(Int)
    case stockIncreasing(Int,Float)
    case editIngredient(Ingredient)
    case updatingStockList
    
//    var description: String{
//       switch self {
//          case .ready                 : return "ready"
//       case .stockDecreasing(let removedQuantity) : return "quantite to be decreased to \(removedQuantity)"
//       case .stockIncreasing(let addedQuantity, let price) : return "stockIncreasing"
//       case .updatingStockList : return "stock list to be updated"
//       }
//    }
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
    
    func intentToIncreaseStock(quantityToBeAdded: Int, totalPriceOfQuantityAdded: Float){
        self.state.send(.stockIncreasing(quantityToBeAdded, totalPriceOfQuantityAdded))
        self.state.send(.updatingStockList)
    }
    func intentToDecreaseStock(quantityToBeRemoved: Int){
        
            self.state.send(.stockDecreasing(quantityToBeRemoved))
            self.state.send(.updatingStockList)
    }
}

