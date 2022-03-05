//
//   NewStepViewModel.swift
//  PolyCook
//
//  Created by Radu Bortan on 02/03/2022.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift

class NewStepViewModel : ObservableObject {
    
    private let firestore  = Firestore.firestore()

    @Published private(set) var ingredients = [Ingredient]()

}
