import Foundation
import Combine

enum CreateRecipeIntentState {
    case dishesChanging(Int)
    case addingStep(Step)
    case modifyingStep(InExtensoStep)
}

struct CreateRecipeIntent {
    private var state = PassthroughSubject<CreateRecipeIntentState, Never>()
    
    func addObserver(viewModel: CreateRecipeViewModel){
        self.state.subscribe(viewModel)
    }
    
    func intentToChange(dishes: Int){
        self.state.send(.dishesChanging(dishes))
    }
    
    func intentToAdd(step : Step){
        self.state.send(.addingStep(step))
    }
    
    func intentToChange(step: InExtensoStep) {
        self.state.send(.modifyingStep(step))
    }
}
