//
//  SettingsView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct SettingsView: View {
    var body: some View {
        NavigationView{
            VStack {
                List {
                    NavigationLink(destination: CoefficientsView()){
                        Text("Coefficients Calcul")
                    }
                    Button{} label: {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right").foregroundColor(.red)
                            Text("Déconnexion").foregroundColor(.red)
                        }
                    }
                }
                .navigationTitle("Paramètres")
                Spacer()
            }
        }
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
