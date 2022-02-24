import Foundation

enum CoefficientsIntentState : Equatable {
    case ready
    case coefficientsChanging
    
    mutating func intentToUpdate() {
        self = .coefficientsChanging
    }
}
