//
//  IngredientView.swift
//  PolyCook
//
//  Created by Radu Bortan on 20/02/2022.
//

import SwiftUI

struct IngredientView: View {
    let bigText = CGFloat(25)
    let smallText = CGFloat(20)
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack (spacing: 20){
            Text("Crevette").font(.system(size: 40)).bold().multilineTextAlignment(.center)
            HStack (spacing: 20){
                VStack (spacing: 10){
                    Text("Prix unitaire")
                        .font(.system(size: bigText))
                    Divider()
                    Text("2.00€")
                        .font(.system(size: smallText))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.textFieldBackground)
                .cornerRadius(10)
                
                VStack (spacing: 10) {
                    Text("Unité")
                        .font(.system(size: bigText))
                    Divider()
                    Text("Kg")
                        .font(.system(size: smallText))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.textFieldBackground)
                .cornerRadius(10)
            }
            
            VStack (spacing: 10) {
                Text("Catégorie")
                    .font(.system(size: bigText))
                Divider()
                Text("Crustacés")
                    .font(.system(size: smallText))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.textFieldBackground)
            .cornerRadius(10)
            
            VStack (spacing: 10) {
                Text("Catégorie d'allergène")
                    .font(.system(size: bigText))
                Divider()
                Text("Crustacés")
                    .font(.system(size: smallText))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.textFieldBackground)
            .cornerRadius(10)

            Spacer()
        }.padding(20)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    showingSheet.toggle()
                } label: {
                    Text("Modifier")
                }
                .sheet(isPresented : $showingSheet) {
                    EditIngredientView()
                }
            }
        }
    }
}

struct IngredientView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientView()
            .preferredColorScheme(.dark)
    }
}
