import Foundation

protocol RecetteObserver {
    func change (nbCouverts: Int)
}

class Recette {
    var observer : RecetteObserver?
    
    var id : String
    
    var nbCouvers : Int {
        didSet {
            if nbCouvers < 1 {
                observer?.change(nbCouverts: oldValue)
            }
            else {
                observer?.change(nbCouverts: nbCouvers)
            }
        }
    }
    var nomAuteur : String
    
    var nomCatRecette : String
    
    var nomRecette : String
    
    var etapes : [String] = []
    
    init(nbCouverts: Int, nomAuteur: String, nomCatRecette: String, nomRecette: String, etapes: [String], id: String = UUID().uuidString) {
        self.id = id
        self.nbCouvers = nbCouverts
        self.nomAuteur = nomAuteur
        self.nomCatRecette = nomCatRecette
        self.nomRecette = nomRecette
        self.etapes = etapes
    }
}
