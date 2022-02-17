//
//  ContentView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct RecipeListView: View {
    var body: some View {
        ZStack {
            Color.red
            Image(systemName: "list.bullet.rectangle.portrait")
                .foregroundColor(Color.white)
                .font(.system(size: 100))
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
