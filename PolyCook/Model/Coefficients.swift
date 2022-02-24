import Foundation

class Coefficients {
    var id : String? = UUID().uuidString
    
    var coeffMultiAvec : Double
    
    var coeffMultiSans: Double
    
    var coutHoraireForfaitaire : Double
    
    var coutHoraireMoyen : Double
    
    init(id: String, coeffMultiAvec: Double, coeffMultiSans: Double, coutHoraireForfaitaire: Double, coutHoraireMoyen: Double) {
        self.id = id
        self.coeffMultiAvec = coeffMultiAvec
        self.coeffMultiSans = coeffMultiSans
        self.coutHoraireForfaitaire = coutHoraireForfaitaire
        self.coutHoraireMoyen = coutHoraireMoyen
    }
}
