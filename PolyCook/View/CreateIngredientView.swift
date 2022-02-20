//
//  AddIngredientView.swift
//  PolyCook
//
//  Created by Radu Bortan on 20/02/2022.
//

import SwiftUI

struct CreateIngredientView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @State var nom : String = ""
    @State var selectedModel : String = "Kg"
    @State var isAllergene : Bool = false
    
    var body: some View {
        VStack (spacing: 20) {
            Capsule()
                    .fill(Color.secondary)
                    .frame(width: 35, height: 5)
                    .padding(10)
            
            Text("Création Ingrédient").font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            VStack (spacing: 5) {
                Text("Nom ingrédient").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                TextField("Nom ingrédient", text: $nom)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.sheetBackground))
                    .foregroundColor(Color.textFieldForeground)
            }
            
            HStack (spacing: 20){
                VStack (spacing: 5) {
                    Text("Unité").font(.title2)
                    Picker("Unité", selection: $selectedModel) {
                        Text("Kg")
                        Text("U")
                        Text("L")
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedModel){ selected in
                    }
                }
                .frame(height: 100, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Color.sheetBackground)
                .cornerRadius(10)
                
                VStack (spacing: 5) {
                    Text("Catégorie").font(.title2)
                    Picker("Catégorie", selection: $selectedModel) {
                        Text("Poisson")
                        Text("Lait")
                    }
                    .pickerStyle(.menu)
                    .onChange(of: selectedModel){ selectedModel in
                    }
                }
                .frame(height: 100, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Color.sheetBackground)
                .cornerRadius(10)
            }
            
            VStack {
                Toggle("Allergène", isOn: $isAllergene).font(.title2)
                
                if isAllergene {
                    VStack (spacing: 5) {
                        Text("Catégorie Allergène").font(.title2)
                        Picker("Catégorie Allergène", selection: $selectedModel) {
                            Text("Poisson")
                            Text("Lait")
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedModel){ selectedModel in
                        }
                    }
                    .frame(height: 100, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .background(Color.sheetBackground)
                    .cornerRadius(10)
                }
            }
            
            HStack (spacing: 20){
                Button(action: {
                    //sauvegarder
                }, label: {
                    Text("Créer")
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
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

struct CreateIngredientView_Previews: PreviewProvider {
    static var previews: some View {
        CreateIngredientView()
    }
}
