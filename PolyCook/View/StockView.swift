//
//  StockView.swift
//  PolyCook
//
//  Created by Radu Bortan on 20/02/2022.
//

import SwiftUI

struct StockView: View {
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack (spacing: 20){
            Capsule()
                    .fill(Color.secondary)
                    .frame(width: 35, height: 5)
                    .padding(10)
            
            Text("Crevette").font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            HStack (spacing: 20){
                VStack (spacing: 10){
                    Text("Prix unitaire")
                        .font(.system(size: 27))
                    Divider()
                    Text("2.00€")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetBackground)
                .cornerRadius(10)
                
                VStack (spacing: 10) {
                    Text("Unité")
                        .font(.system(size: 27))
                    Divider()
                    Text("Kg")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetBackground)
                .cornerRadius(10)
            }
            
            HStack (spacing: 20) {
                VStack (spacing: 10) {
                    Text("Catégorie")
                        .font(.system(size: 27))
                    Divider()
                    Text("Crustacés")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetBackground)
                .cornerRadius(10)
                
                VStack (spacing: 10) {
                    Text("Quantité")
                        .font(.system(size: 27))
                    Divider()
                    Text("2")
                        .font(.title2)
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetBackground)
                .cornerRadius(10)
            }
            
            VStack (spacing: 10) {
                Text("Catégorie d'allergène")
                    .font(.system(size: 27))
                Divider()
                Text("Crustacés")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.sheetBackground)
            .cornerRadius(10)

            Button(action: {
                showingSheet.toggle()
            }, label: {
                Text("Modifier Stock")
                    .font(.title2)
                    .foregroundColor(.white).padding(12)
            }).frame(maxWidth: .infinity).background(.blue).cornerRadius(10)
                .sheet(isPresented : $showingSheet) {
                    ModifyStockView()
                }
            
            Spacer()
        }
        .padding([.leading, .trailing], 20)
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView()
            .preferredColorScheme(.dark)
    }
}
