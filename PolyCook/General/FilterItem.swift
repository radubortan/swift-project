import Foundation
import SwiftUI



class FilterItem : ObservableObject{
    @Published var checked : Bool = false
    var title : String
    
    init(title: String){
        self.title = title
    }
}
