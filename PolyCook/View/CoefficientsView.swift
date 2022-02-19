//
//  OptionsView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct CoefficientsView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    //formats the entered values
    let numberFormatter : NumberFormatter
    
    init(){
        numberFormatter = NumberFormatter()
        //to format into decimal numbers
        numberFormatter.numberStyle = .decimal
    }
    
    
    @State var coutHoraireMoyen : Double = 0
    @State var coutHoraireForfaitaire : Double = 0
    @State var coeffSans : Double = 0
    @State var coeffAvec : Double = 0
    
    //used for dismissing the keyboard
    private enum Field: Int, CaseIterable {
        case coutHoraireMoyen, coutHoraireForfaitaire, coeffSans, coeffAvec
    }
    @FocusState private var focusedField: Field?
    
    
    var body: some View {
        VStack{
            Text("Coefficients").font(.system(size: 40)).bold().padding([.top, .bottom], 20)
            VStack (spacing: 0){
                VStack (spacing: 18){
                    Text("Coûts horaires").font(.system(size: 25)).bold()
                    VStack (spacing: 5) {
                        Text("Coût horaire moyen").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                        TextField("Coût horaire moyen", value: $coutHoraireMoyen, formatter: numberFormatter)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.textFieldBackground))
                            .foregroundColor(Color.textFieldForeground)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .coutHoraireMoyen)
                    }
                    
                    VStack (spacing: 5) {
                        Text("Coût horaire forfaitaire").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                        TextField("Coût horaire forfaitaire", value: $coutHoraireForfaitaire, formatter: numberFormatter)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.textFieldBackground))
                            .foregroundColor(Color.textFieldForeground)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .coutHoraireForfaitaire)
                    }
                }
                
                Divider().padding([.top, .bottom], 30)
                
                VStack (spacing: 18){
                    Text("Coefficients multiplicateurs").font(.system(size: 25)).bold()
                    VStack (spacing: 5) {
                        Text("Sans évalution").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                        TextField("Sans évalution", value: $coeffSans, formatter: numberFormatter)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.textFieldBackground))
                            .foregroundColor(Color.textFieldForeground)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .coeffSans)
                    }
                    
                    VStack (spacing: 5) {
                        Text("Avec évalution").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10)
                        TextField("Avec évalution", value: $coeffAvec, formatter: numberFormatter)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.textFieldBackground))
                            .foregroundColor(Color.textFieldForeground)
                            .disableAutocorrection(true)
                            .autocapitalization(.none)
                            .keyboardType(.decimalPad)
                            .focused($focusedField, equals: .coeffAvec)
                    }
                }
            }
            //to be able to put away the keyboard
            .toolbar {
                ToolbarItemGroup(placement: .keyboard) {
                    Spacer()
                    Button("Fini") {
                        focusedField = nil
                    }
                }
            }
            
            Spacer().frame(height: 30)
            
            HStack{
                Button(action: {
                    //sauvegarder
                }, label: {
                    Text("Sauvegarder")
                        .font(.system(size: 18)).foregroundColor(.white).padding(12)
                }).frame(width: 150).background(.blue).cornerRadius(10)
                
                Spacer()
                
                Button(action: {
                    //dismissed the current view
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Annuler")
                        .font(.system(size: 18)).foregroundColor(.white).padding(12)
                }).frame(width: 150).background(.red).cornerRadius(10)
            }
            Spacer()
        }
        .padding([.leading, .trailing], 30)
        .navigationBarTitle("test")
        .navigationBarHidden(true)
    }
}

struct CoefficientsView_Previews: PreviewProvider {
    static var previews: some View {
        CoefficientsView()
    }
}
