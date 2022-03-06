import Foundation
import Combine
import SwiftUI

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
            self.recipe.addStep(step: step)
        case .modifyingStep(let step):
            for (index, existingStep) in self.recipe.etapes.enumerated() {
                if existingStep.id == step.id {
                    self.recipe.changeStep(step: step, index: index)
                }
            }
        }
        return .none
    }
    
    func receive(completion: Subscribers.Completion<Never>) {
        return
    }
    
    var listIntent : RecipeListIntent
    var creationIntent : CreateRecipeIntent
    var recipe : Recette
    
    //formats the entered values
    let numberFormatter = NumberFormatter()
    
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
    @Published var recipes : [Recette]
    
    func change(nbCouverts: Int) {
        self.dishes = nbCouverts
    }
    
    func change(step: Step) {
        self.etapes.append(step)
    }
    
    func change(step: InExtensoStep, index: Int) {
        self.etapes[index] = step
    }
    
    init(listVm : RecipeListViewModel, recipes: [Recette]) {
        self.listIntent = RecipeListIntent()
        self.listIntent.addObserver(viewModel : listVm)
        self.creationIntent = CreateRecipeIntent()
        self.recipe = Recette(nbCouverts: 1, nomAuteur: "", nomCatRecette: "", nomRecette: "", etapes: [])
        self.recipes = recipes
        self.creationIntent.addObserver(viewModel: self)
        self.recipe.observer = self
        
    }
    
    func deleteStep(at indexSet: IndexSet) {
        withAnimation {
            etapes.remove(atOffsets: indexSet)
        }
    }
    
    func moveStep(from source: IndexSet, to destination: Int) {
            etapes.move(fromOffsets: source, toOffset: destination)
        }
    
    func clearView() {
        mealType = "Entrée"
        nomRecette = ""
        nomAuteur = ""
        dishes = 1
        etapes = []
    }
}
