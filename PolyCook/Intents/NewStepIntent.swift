import Foundation
import Combine

enum NewStepIntentState {
    case dishesChanging(Int)
}

struct NewStepIntent {
    private var state = PassthroughSubject<NewStepIntentState, Never>()
    
    func addObserver(viewModel: CreateRecipeViewModel){
        self.state.subscribe(viewModel)
    }
    
    func intentToChange(dishes: Int){
        self.state.send(.dishesChanging(dishes))
    }
}
