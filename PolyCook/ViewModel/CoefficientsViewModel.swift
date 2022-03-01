import Foundation
import Combine
import FirebaseFirestore
import FirebaseFirestoreSwift

class CoefficientsViewModel : ObservableObject{
    private let firestore = Firestore.firestore()
    
    //model
    private var coefficients : Coefficients = Coefficients(id: "0", coeffMultiAvec: 0, coeffMultiSans: 0, coutHoraireForfaitaire: 0, coutHoraireMoyen: 0)
    
    //published field values
    @Published var coeffMultiAvec : Double = 0
    @Published var coeffMultiSans : Double = 0
    @Published var coutHoraireForfaitaire : Double = 0
    @Published var coutHoraireMoyen : Double = 0
    
    init() {
        //fetching the data when the view loads
        Task {
            loadCoefficients()

        }
    }
    
    //function to fetch the data
    func loadCoefficients() {
        firestore.collection("options")
            .addSnapshotListener {
                (data, error) in
                guard let documents = data?.documents else {
                    return
                }
                self.coefficients = Coefficients (
                    id: documents[0].documentID,
                    coeffMultiAvec: documents[0]["coeffMultiAvec"] as? Double ?? 0,
                    coeffMultiSans: documents[0]["coeffMultiSans"] as? Double ?? 0,
                    coutHoraireForfaitaire: documents[0]["coutHoraireForfaitaire"] as? Double ?? 0,
                    coutHoraireMoyen: documents[0]["coutHoraireMoyen"] as? Double ?? 0
                )
                //initializing the view model field values with data from the DB
                self.coeffMultiAvec = self.coefficients.coeffMultiAvec
                self.coeffMultiSans = self.coefficients.coeffMultiSans
                self.coutHoraireMoyen = self.coefficients.coutHoraireMoyen
                self.coutHoraireForfaitaire = self.coefficients.coutHoraireForfaitaire
            }
    }
    
    //function to update the data in the DB
    func updateCoefficients() {
        self.coefficients.coeffMultiAvec = self.coeffMultiAvec
        self.coefficients.coeffMultiSans = self.coeffMultiSans
        self.coefficients.coutHoraireMoyen = self.coutHoraireMoyen
        self.coefficients.coutHoraireForfaitaire = self.coutHoraireForfaitaire
        
        firestore.collection("options")
            .document(coefficients.id!)
            .setData(["coeffMultiAvec" : coefficients.coeffMultiAvec,
                      "coeffMultiSans" : coefficients.coeffMultiSans,
                      "coutHoraireForfaitaire" : coefficients.coutHoraireForfaitaire,
                      "coutHoraireMoyen" : coefficients.coutHoraireMoyen
                     ], merge: true)
    }
    
    //function to reset the view model values to the values from the DB
    func resetValues() {
        self.coeffMultiAvec = self.coefficients.coeffMultiAvec
        self.coeffMultiSans = self.coefficients.coeffMultiSans
        self.coutHoraireMoyen = self.coefficients.coutHoraireMoyen
        self.coutHoraireForfaitaire = self.coefficients.coutHoraireForfaitaire
    }
}
