import Foundation
import Combine

enum RecipeListIntentState {
    case ready
    case addingRecipe(Recette)
}

struct RecipeListIntent {
    private var state = PassthroughSubject<RecipeListIntentState, Never>()
    
    func addObserver(viewModel: RecipeListViewModel){
        self.state.subscribe(viewModel)
    }
    
    func intentToAdd(recette: Recette){
        self.state.send(.addingRecipe(recette))
    }
}
