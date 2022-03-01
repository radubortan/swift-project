import Foundation
import Combine

class CreateRecipeViewModel : ObservableObject, RecetteObserver, Subscriber {
    
    typealias Input = CreateRecipeIntentState
    
    typealias Failure = Never
    
    func receive(subscription: Subscription) {
        subscription.request(.unlimited)
    }
    
    func receive(_ input: CreateRecipeIntentState) -> Subscribers.Demand {
        switch input{
        case .dishesChanging(let dishes):
            self.recipe.nbCouverts = dishes
        case .addingStep(let step):
            self.recipe.etapes.append(step)
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    var listIntent : RecipeListIntent
    var creationIntent : CreateRecipeIntent
    
    @Published var mealType : String = "Entrée"
    @Published var nomRecette : String = ""
    @Published var nomAuteur : String = ""
    @Published var dishes : Int = 1
    
    @Published var newStepSheetIsOn = false
    @Published var costsSheetIsOn = false
    @Published var ingredientsSheetIsOn = false
    @Published var showStep = false
    @Published var showSubmitError = false
    
    @Published var etapes : [Step] = []
    
    func change(nbCouverts: Int) {
        self.dishes = nbCouverts
    }
    
    func change(step: Step) {
        self.etapes.append(step)
    }
    
    var recipe : Recette
    
    //formats the entered values
    let numberFormatter = NumberFormatter()
    
    init(listVm : RecipeListViewModel) {
        self.listIntent = RecipeListIntent()
        self.listIntent.addObserver(viewModel : listVm)
        self.creationIntent = CreateRecipeIntent()
        self.recipe = Recette(nbCouverts: 1, nomAuteur: "", nomCatRecette: "", nomRecette: "", etapes: [])
        self.creationIntent.addObserver(viewModel: self)
        self.recipe.observer = self
    }
}
