//
//  IngredientListView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct IngredientListView: View {
    var body: some View {
        ZStack {
            Color.purple
            Image(systemName: "cart")
                .foregroundColor(Color.white)
                .font(.system(size: 100))
        }
    }
}

struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientListView()
    }
}
