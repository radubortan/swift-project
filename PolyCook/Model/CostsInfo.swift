//
//  CostInfo.swift
//  PolyCook
//
//  Created by Radu Bortan on 05/03/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class CostsInfo : ObservableObject {
    
    private let firestore = Firestore.firestore()

    //custom coefficients
    @Published var customParams : Bool = false
    @Published var customCoutHoraireMoyen : Double = 0
    @Published var customCoutHoraireForfaitaire : Double = 0
    @Published var customCoeffMultiSans : Double = 0
    @Published var customCoeffMultiAvec : Double = 0
    
    //custom assaisonnement
    @Published var customAssaisonnement : Bool = false
    @Published var customAssaissonnementValue : Double = 0
    
    @Published var withCharges : Bool = false
    
    //global coefficients
    @Published var coutHoraireMoyen : Double = 0
    @Published var coutHoraireForfaitaire : Double = 0
    @Published var coeffMultiSans : Double = 0
    @Published var coeffMultiAvec : Double = 0
    
    init(){
        Task{
            loadCoefficients()
        }
    }
    
    func loadCoefficients() {
        firestore.collection("options")
            .addSnapshotListener {
                (data, error) in
                guard let documents = data?.documents else {
                    return
                }
                self.coeffMultiAvec = documents[0]["coeffMultiAvec"] as? Double ?? 0
                self.coeffMultiSans = documents[0]["coeffMultiSans"] as? Double ?? 0
                self.coutHoraireForfaitaire = documents[0]["coutHoraireForfaitaire"] as? Double ?? 0
                self.coutHoraireMoyen = documents[0]["coutHoraireMoyen"] as? Double ?? 0
            
            }
    }
}
