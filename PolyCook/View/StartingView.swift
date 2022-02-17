//
//  StartingView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct StartingView: View {
    var body: some View {
        TabView {
            RecipeListView()
                .tabItem(){
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text("Recettes")
                }
            StocksListView()
                .tabItem(){
                    Image(systemName: "shippingbox")
                    Text("Stock")
                }
            IngredientListView()
                .tabItem(){
                    Image(systemName: "cart")
                    Text("Ingrédients")
                }
            SettingsView()
                .tabItem(){
                    Image(systemName: "gear")
                    Text("Paramètres")
                }
        }
    }
}

struct StartingView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            StartingView()
                .previewInterfaceOrientation(.portrait)
        }
    }
}
