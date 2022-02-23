import SwiftUI

struct NewStepView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    let ingredients = ["Pomme", "Tomate"]
    
    @State var isRecipe = false
    @State var nomEtape = ""
    @State var duration = 1
    @State var description = ""
    @State var ingredient = "Poisson"
    @State var recipe = "Sauce tomate"
    @State var quantity = 1
    @State var subrecipeQuantity = 1
    
    //formats the entered values
    let numberFormatter = NumberFormatter()
    
    func deletion(at indexSet: IndexSet) {
        
    }
    
    var body: some View {
        List {
            Section {
                VStack (spacing: 20){
                    Text("Création étape").font(.system(size: 40)).bold().multilineTextAlignment(.center)
                    VStack (spacing: 5) {
                        Text("Titre étape").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                        TextField("Titre étape", text: $nomEtape)
                            .padding(10)
                            .background(RoundedRectangle(cornerRadius: 10)
                                            .fill(Color.sheetElementBackground))
                            .foregroundColor(Color.textFieldForeground)
                    }
                }
                .listRowBackground(Color.white.opacity(0))
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            
            Section {
                HStack {
                    Spacer()
                    Text("In extenso")
                    Toggle("", isOn: $isRecipe.animation(.linear(duration: 0.3))).labelsHidden()
                    Text("Recette")
                    Spacer()
                }
                
            }
            .listRowBackground(Color.white.opacity(0))
            .padding(.top, 20)
            
            if isRecipe {
                //information
                Section (header: Text("Informations")
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
                                Text("Recette").font(.title2)
                                Picker("Recette", selection: $recipe) {
                                    Text("Sauce tomate").tag("Sauce tomate")
                                    Text("Crème fromagère").tag("Crème fromagère")
                                }
                                .pickerStyle(.menu)
                            }
                            .frame(height: 100, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color.sheetElementBackground)
                            .cornerRadius(10)
                            
                            VStack (spacing: 5) {
                                Text("N° Couverts").font(.title2)
                                TextField("N° Couverts", value: $subrecipeQuantity, formatter: numberFormatter)
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
                    }
                    .listRowBackground(Color.white.opacity(0))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
                
                //ingredient list
                Section (header: Text("Ingrédients")
                            .font(.system(size: 30))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 30)
                            .padding(.bottom, 5)
                            .textCase(.none)
                            .foregroundColor(Color.textFieldForeground)) {
                    ForEach(ingredients, id: \.self) {ingredient in
                        HStack {
                            Text(ingredient)
                            Spacer()
                            Text("10")
                                .frame(width: 30, height: 30)
                                .background(Color.innerTextFieldBackground)
                                .cornerRadius(10)
                                .foregroundColor(Color.textFieldForeground)
                        }
                    }
                }
            }
            else {
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
                            TextField("Durée (min)", value: $duration, formatter: numberFormatter)
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
                                TextEditor(text: $description)
                                    .padding(10)
                                    .frame(height: 200)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.sheetElementBackground))
                                    .foregroundColor(Color.textFieldForeground)
                                if description.isEmpty {
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
                                Picker("Ingrédient", selection: $ingredient) {
                                    Text("Poisson").tag("Poisson")
                                    Text("Tomate").tag("Tomate")
                                    Text("Poulet").tag("Poulet")
                                }
                                .pickerStyle(.menu)
                            }
                            .frame(height: 100, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color.sheetElementBackground)
                            .cornerRadius(10)
                            
                            VStack (spacing: 5) {
                                Text("Quantité (Kg)").font(.title2)
                                TextField("Quantité (Kg)", value: $quantity, formatter: numberFormatter)
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
                            
                        }, label: {
                            HStack {
                                Image(systemName: "plus")
                                    .font(.title2)
                                Text("Ajouter ingrédient")
                                    .font(.title2)
                                    .padding(.vertical, 12)
                            }
                        })
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.blue)
                            .cornerRadius(10)
                            .foregroundColor(.white)
                            .buttonStyle(BorderlessButtonStyle())
                    }
                    .listRowBackground(Color.white.opacity(0))
                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    
                }
                
                //ingredient list
                Section {
                    ForEach(ingredients, id: \.self) {ingredient in
                        HStack {
                            Text(ingredient)
                            Spacer()
                            Text("10")
                                .frame(width: 30, height: 30)
                                .background(Color.innerTextFieldBackground)
                                .cornerRadius(10)
                                .foregroundColor(Color.textFieldForeground)
                        }
                    }
                    .onDelete(perform: deletion)
                }
            }
            
            //confirm buttons
            Section {
                HStack (spacing: 20){
                    Button(action: {
                        //sauvegarder
                    }, label: {
                        Text("Créer")
                            .font(.title2)
                            .foregroundColor(.white)
                            .padding(12)
                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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

struct NewStepView_Previews: PreviewProvider {
    static var previews: some View {
        NewStepView()
    }
}
