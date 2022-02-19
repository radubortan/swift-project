//
//  StartingView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI
import FirebaseAuth

struct StartingView: View {
    @EnvironmentObject var loginVM : LoginViewModel
    
    let auth = Auth.auth()
    
    var isSignedIn : Bool {
        return auth.currentUser != nil
    }
    
    var body: some View {
        TabView {
            RecipeListView()
                .tabItem(){
                    Image(systemName: "list.bullet.rectangle.portrait")
                    Text("Recettes")
                }
            if loginVM.signedIn {
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
            else {
                LoginView()
                    .tabItem(){
                        Image(systemName: "person.circle.fill")
                        Text("Connexion")
                    }
            }
        }
        .onAppear{
            loginVM.signedIn = loginVM.isSignedIn
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
