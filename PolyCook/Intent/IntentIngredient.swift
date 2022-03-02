import Foundation
import Combine


enum IngredientError: Error, CustomStringConvertible, Equatable{
   case tooShortName(String)
   case unknown
   var  description: String{
      switch self{
         case .tooShortName(let name): return "name must be at least 3 characters length: \(name)"
         default: return "unknown error on ingredient name"
      }
   }
}

enum IntentIngredientState : Equatable {
    case ready
    case nomIngChanging(String)
    case nomIngChanged(String)
    case nomIngError(IngredientError)
    case nomCatChanging(String)
    case nomCatAllergChanging(String?)
    case addIngredient(Ingredient)
    case editIngredient(Ingredient)
    case updatingIngredientList
    
    var description: String{
       switch self {
          case .ready                 : return "ready"
       case .nomIngChanging(let nomIng): return "nomIng to be changed to \(nomIng)"
       case .nomIngChanged(let nomIng) : return "nomIng changed to: \(nomIng)"
       case .nomIngError(let error)  : return "\(error)"
       case .nomCatChanging(let nomCat): return "nomCat to be changed to \(nomCat)"
       case .nomCatAllergChanging(let nomCatAllerg): return "nomCatAllerg to be changed to \(String(describing: nomCatAllerg))"
       case .addIngredient(_) : return "ingredient to be added"
       case .editIngredient(_) : return "ingredient to be edited"
       case .updatingIngredientList : return "ingredient list to be updated"
       }
    }
    
    mutating func intentToChange(nomIng: String){
        let newNomIng = nomIng.trimmingCharacters(in: .whitespacesAndNewlines)
        if newNomIng.count < 3{
            self = .nomIngError(.tooShortName(newNomIng))
        }
        else{
            self = .nomIngChanging(nomIng)
        }
    }
}

struct IntentIngredient {
    private var state = PassthroughSubject<IntentIngredientState, Never>()
    
    func viewUpdated(){
        self.state.send(.ready)
    }
    
    func addObserver(viewModel: IngredientViewModel){
        self.state.subscribe(viewModel)
    }
    
    func addObserver(viewModel: IngredientListViewModel){
        self.state.subscribe(viewModel)
    }
    
    func intentToAddIngredient(ingredient: Ingredient){
        self.state.send(.addIngredient(ingredient))
        self.state.send(.updatingIngredientList)
    }
    
    func intentToEditIngredient(ingredient: Ingredient){
        self.state.send(.editIngredient(ingredient))
        self.state.send(.updatingIngredientList)
    }
    
    func intentToChange(nomIng: String){
        self.state.send(.nomIngChanging(nomIng))
        self.state.send(.updatingIngredientList)
    }
    
    func intentToChange(nomCat: String){
        self.state.send(.nomCatChanging(nomCat))
        self.state.send(.updatingIngredientList)
    }
    
    func intentToChange(nomCatAllerg: String?){
        self.state.send(.nomCatAllergChanging(nomCatAllerg))
        self.state.send(.updatingIngredientList)
    }
}
