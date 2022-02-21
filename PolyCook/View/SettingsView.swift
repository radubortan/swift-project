//
//  SettingsView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var loginVM : LoginViewModel
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    Section() {
                        NavigationLink(destination: CoefficientsView()){
                            Text("Coefficients")
                                .font(.system(size: 21))
                        }
                    }
                    
                    Section() {
                        Button{
                            loginVM.signOut()
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
//                                    .foregroundColor(.white)
                                Text("Déconnexion")
                                    .foregroundColor(.red)
//                                    .foregroundColor(.white)
                                    .font(.system(size: 21))
                            }
//                            .padding(10)
                        }
                        .frame(maxWidth: .infinity)
//                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                        .background(.red)
                    }
                }
                Spacer()
            }
            .navigationTitle("Paramètres")
        }
        .navigationViewStyle(StackNavigationViewStyle()) //to fix constraints error that appear in the console due to navigationTitle
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
