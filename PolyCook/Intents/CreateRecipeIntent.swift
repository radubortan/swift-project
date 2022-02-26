import Foundation
import Combine

enum CreateRecipeIntentState {
    case dishesChanging(Int)
}

struct CreateRecipeIntent {
    private var state = PassthroughSubject<CreateRecipeIntentState, Never>()
    
    func addObserver(viewModel: CreateRecipeViewModel){
        self.state.subscribe(viewModel)
    }
    
    func intentToChange(dishes: Int){
        self.state.send(.dishesChanging(dishes))
    }
}
