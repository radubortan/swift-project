//
//  EditInExtensoStepView.swift
//  PolyCook
//
//  Created by Radu Bortan on 06/03/2022.
//

import SwiftUI

struct EditInExtensoStepView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var stepVm : EditInExtensoStepViewModel
    
    init(listVm: CreateRecipeViewModel, step: InExtensoStep) {
        self.stepVm = EditInExtensoStepViewModel(listVm: listVm, step: step)
    }
    
    var body: some View {
        List {
            Section {
                VStack (spacing: 20){
                    Text("Modification étape").font(.system(size: 40)).bold().multilineTextAlignment(.center)
                    VStack (spacing: 5) {
                        Text("Titre étape").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                        TextField("Titre étape", text: $stepVm.nomEtape)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.sheetElementBackground))
                            .foregroundColor(Color.textFieldForeground)
                    }
                }
                .listRowBackground(Color.white.opacity(0))
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
                //information
                Section (header: Text("Informations")
                            .font(.system(size: 30))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 30)
                            .padding(.bottom, 5)
                            .textCase(.none)
                            .foregroundColor(Color.textFieldForeground)) {
                    VStack (spacing: 20){
                        VStack (spacing: 5) {
                            Text("Durée (min)").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                            TextField("Durée (min)", value: $stepVm.duration, formatter: stepVm.numberFormatter)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.sheetElementBackground))
                                .foregroundColor(Color.textFieldForeground)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        
                        VStack (spacing: 5) {
                            Text("Description").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                            ZStack (alignment: .leading){
                                TextEditor(text: $stepVm.description)
                                    .padding(10)
                                    .frame(height: 200)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.sheetElementBackground))
                                    .foregroundColor(Color.textFieldForeground)
                                if stepVm.description.isEmpty {
                                    VStack {
                                        Text("Description...")
                                            .foregroundColor(Color.placeholderColor)
                                            .padding(.all)
                                            .padding(.top, 2)
                                        Spacer()
                                    }
                                }
                            }
                        }
                    }
                    .listRowBackground(Color.white.opacity(0))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                
                //add ingredient
                Section (header: Text("Ingrédients")
                            .font(.system(size: 30))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 30)
                            .padding(.bottom, 5)
                            .textCase(.none)
                            .foregroundColor(Color.textFieldForeground)) {
                    VStack (spacing: 20) {
                        HStack (spacing: 20){
                            VStack (spacing: 5) {
                                Text("Ingrédient").font(.title2)
                                if stepVm.ingredients.isEmpty {
                                    Text("Aucun ingrédient").foregroundColor(Color.red)
                                }
                                else {
                                    Picker("Ingrédient", selection: $stepVm.selectedIngredient) {
                                        ForEach(stepVm.ingredients) { ingredient in
                                            Text(ingredient.nomIng).tag(ingredient)
                                        }
                                    }
                                    .id(UUID())
                                    .pickerStyle(.menu)
                                }
                            }
                            .frame(height: 100, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color.sheetElementBackground)
                            .cornerRadius(10)
                            
                            VStack (spacing: 5) {
                                Text("Quantité (\(stepVm.selectedIngredient.unite))").font(.title2)
                                TextField("Quantité", value: $stepVm.quantity, formatter: stepVm.numberFormatter)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.innerTextFieldBackground))
                                    .foregroundColor(Color.textFieldForeground)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                            .padding(15)
                            .frame(height: 100, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color.sheetElementBackground)
                            .cornerRadius(10)
                        }
                        Button(action: {
                            stepVm.addIngredient(ingredient: stepVm.selectedIngredient, quantity: Double(stepVm.quantity))
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.title2)
                                Text("Ajouter ingrédient")
                                    .font(.title2)
                                    .padding(.vertical, 12)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                        })
                            
                            .background(stepVm.ingredients.isEmpty ? .gray : .blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .buttonStyle(BorderlessButtonStyle())
                            .disabled(stepVm.ingredients.isEmpty)
                    }
                    .listRowBackground(Color.white.opacity(0))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                }
                
                //ingredient list
                Section {
                    if stepVm.ingredientsList.isEmpty {
                        Text("Aucun ingrédient")
                            .font(.system(size: 21))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 20)
                            .listRowBackground(Color.white.opacity(0))
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    else {
                        ForEach(stepVm.ingredientsList, id: \.id) {ingredient in
                                HStack {
                                    Text(ingredient.ingredient.nomIng)
                                    Spacer()
                                    if (ingredient.ingredient.nomCatAllerg != nil) {
                                        Image(systemName: "exclamationmark.circle")
                                            .resizable()
                                            .frame(width: 20, height: 20)
                                            .foregroundColor(.red)
                                    }
                                    Text("\(String(format: "%.1f", ingredient.quantity)) \(ingredient.ingredient.unite)")
                                        .frame(width: 75, height: 30)
                                        .background(Color.innerTextFieldBackground)
                                        .cornerRadius(10)
                                        .foregroundColor(Color.textFieldForeground)
                                }
                        }
                        .onDelete(perform: stepVm.deleteIngredient)
                    }
                }
            
            
            //confirm buttons
            Section {
                HStack (spacing: 20){
                    Button(action: {
                        stepVm.listIntent.intentToChange(step: InExtensoStep(nomEtape: stepVm.nomEtape, duree: stepVm.duration, description: stepVm.description, ingredients: stepVm.ingredientsList, id: stepVm.step.id))
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Modifier")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    })
                        
                        .background(.blue)
                        .cornerRadius(10)
                        .buttonStyle(BorderlessButtonStyle())
                    
                    Button(action: {
                        //dismissed the current view
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Annuler")
                            .font(.title2)
                            .foregroundColor(.white).padding(12)
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    })
                        
                        .background(.red)
                        .cornerRadius(10)
                        .buttonStyle(BorderlessButtonStyle())
                }
                
            }
            .listRowBackground(Color.white.opacity(0))
            .padding(.top, 40)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .interactiveDismissDisabled()
    }
}

//struct EditInExtensoStepView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditInExtensoStepView()
//    }
//}
