//
//  CustomSheet.swift
//  PolyCook
//
//  Created by Radu Bortan on 21/02/2022.
//

import SwiftUI

enum SheetMode {
    case none
    case quarter
    case half
}

struct CustomSheet<Content: View>: View {
    
    let content : () -> Content
    var sheetMode : Binding<SheetMode>
    
    private func calculateOffset() -> CGFloat {
        switch sheetMode.wrappedValue {
        case .none:
            return UIScreen.main.bounds.height
        case .quarter:
            return UIScreen.main.bounds.height - 200
        case .half:
            return UIScreen.main.bounds.height / 2
        }
    }
    
    init(sheetMode: Binding<SheetMode>, @ViewBuilder content: @escaping () -> Content) {
        self.content = content
        self.sheetMode = sheetMode
    }
    
    var body: some View {
        content()
            .offset(y: calculateOffset())
            .animation(.spring())
            .edgesIgnoringSafeArea(.all)
    }
}

struct CustomSheet_Previews: PreviewProvider {
    static var previews: some View {
        CustomSheet(sheetMode: .constant(.none)){
            VStack {
                Text("Hello World")
            }
        }
    }
}
