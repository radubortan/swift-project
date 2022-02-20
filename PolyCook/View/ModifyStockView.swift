//
//  ModifyStockView.swift
//  PolyCook
//
//  Created by Radu Bortan on 20/02/2022.
//

import SwiftUI

struct ModifyStockView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @State var isAdding : Bool = false
    @State var increase : Double = 0
    @State var decrease : Double = 0
    @State var price : Double = 0
    
    //formats the entered values
    let numberFormatter : NumberFormatter
    
    init(){
        numberFormatter = NumberFormatter()
        //to format into decimal numbers
        numberFormatter.numberStyle = .decimal
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Capsule()
                    .fill(Color.secondary)
                    .frame(width: 35, height: 5)
                    .padding(10)
            
            Text("Lait").font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            HStack {
                Text("Enlever")
                Toggle("", isOn: $isAdding).labelsHidden()
                Text("Ajouter")
            }
            
            VStack (spacing: 10) {
                Text("Quantité actuelle")
                    .font(.system(size: 27))
                Divider()
                Text("2 L")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.sheetBackground)
            .cornerRadius(10)
            
            VStack (spacing: 10) {
                Text("Nouvelle quantité")
                    .font(.system(size: 27))
                Divider()
                Text("2 L")
                    .font(.title2)
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.sheetBackground)
            .cornerRadius(10)
            
            if isAdding {
                VStack (spacing: 5) {
                    Text("Augmentation (L)").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                    TextField("Augmentation (L)", value: $increase, formatter: numberFormatter)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.sheetBackground))
                        .foregroundColor(Color.textFieldForeground)
                }
                
                VStack (spacing: 5) {
                    Text("Coût d'achat total (€)").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                    TextField("Coût d'achat total (€)", value: $price, formatter: numberFormatter)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.sheetBackground))
                        .foregroundColor(Color.textFieldForeground)
                }
            }
            else {
                VStack (spacing: 5) {
                    Text("Diminution (L)").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                    TextField("Diminution (L)", value: $decrease, formatter: numberFormatter)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.sheetBackground))
                        .foregroundColor(Color.textFieldForeground)
                }
            }
            
            HStack (spacing: 20){
                Button(action: {
                    //sauvegarder
                }, label: {
                    Text("Modifier")
                        .font(.title2)
                        .foregroundColor(.white).padding(12)
                }).frame(maxWidth: .infinity).background(.blue).cornerRadius(10)
                
                Button(action: {
                    //dismissed the current view
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Annuler")
                        .font(.title2)
                        .foregroundColor(.white).padding(12)
                }).frame(maxWidth: .infinity).background(.red).cornerRadius(10)
            }
            
            Spacer()
        }
        .padding([.leading, .trailing], 20)
    }
}

struct ModifyStockView_Previews: PreviewProvider {
    static var previews: some View {
        ModifyStockView()
    }
}
