import Foundation

protocol RecetteObserver {
    func change (nbCouverts: Int)
    func change (step: Step)
}

class Recette : Step {
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
    
    init(nbCouverts: Int, nomAuteur: String, nomCatRecette: String, nomRecette: String, etapes: [Step], nomEtape : String = "", id: String = UUID().uuidString) {
        self.nbCouverts = nbCouverts
        self.nomCatRecette = nomCatRecette
        self.nomRecette = nomRecette
        self.etapes = etapes
        self.nomAuteur = nomAuteur
        super.init(id : id, nomEtape : nomEtape)
    }
}
