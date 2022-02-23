import Foundation
import SwiftUI

struct CustomCorner: Shape {
    
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 15, height: 15))
        return Path(path.cgPath)
    }
}
