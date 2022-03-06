import Foundation

protocol RecetteObserver {
    func change (nbCouverts: Int)
    func change (step: Step)
}

class Recette : Step, Identifiable, Hashable {
    static func == (lhs: Recette, rhs: Recette) -> Bool {
        return lhs === rhs
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
    
    var observer : RecetteObserver?
    
    var nomAuteur : String
    
    var nbCouverts : Int {
        didSet {
            if nbCouverts < 1 {
                observer?.change(nbCouverts: oldValue)
            }
            else {
                observer?.change(nbCouverts: nbCouverts)
            }
        }
    }
    
    
    var nomCatRecette : String
    
    var nomRecette : String
    
    var etapes : [Step] = []
    {
        didSet {
            observer?.change(step: etapes.last!)
        }
    }
    
    var hasAllergens : Bool {
        let ingredients = RecipeManipulator.extractIngredients(steps: etapes)
        return ingredients.contains(where: {$0.ingredient.nomCatAllerg != nil})
    }
    
    init(nbCouverts: Int, nomAuteur: String, nomCatRecette: String, nomRecette: String, etapes: [Step], nomEtape : String = "", id: String = UUID().uuidString) {
        self.nbCouverts = nbCouverts
        self.nomCatRecette = nomCatRecette
        self.nomRecette = nomRecette
        self.etapes = etapes
        self.nomAuteur = nomAuteur
        super.init(id : id, nomEtape : nomEtape)
    }
}
