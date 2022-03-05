//
//  CostInfo.swift
//  PolyCook
//
//  Created by Radu Bortan on 05/03/2022.
//

import Foundation

class CostsInfo : ObservableObject {
    @Published var customParams : Bool = false
    @Published var customCoutHoraireMoyen : Double = 0
    @Published var customCoutHoraireForfaitaire : Double = 0
    @Published var customCoeffMultiSans : Double = 0
    @Published var customCoeffMultiAvec : Double = 0
    
    @Published var customAssaisonnement : Bool = false
    @Published var customAssaissonnementValue : Double = 0
    @Published var withCharges : Bool = false
}
