//
//  CustomCorner.swift
//  PolyCook
//
//  Created by Radu Bortan on 21/02/2022.
//

import Foundation
import SwiftUI
import UIKit

struct CustomCorner: Shape {
    
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 35, height: 35))
        return Path(path.cgPath)
    }
}
