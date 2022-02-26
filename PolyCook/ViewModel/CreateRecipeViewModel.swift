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
            print(".dishesChanging \(dishes)")
            self.recipe.nbCouvers = dishes
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
    
    @Published var etapes = ["etape 1", "etape 2", "etape 3", "etape 4"]
    
    func change(nbCouverts: Int) {
        self.dishes = nbCouverts
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
