import SwiftUI

struct CreateRecipeView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var listVm : RecipeListViewModel
    @ObservedObject var createVm : CreateRecipeViewModel
    
    init(listVm : RecipeListViewModel) {
        self.listVm = listVm
        self.createVm = CreateRecipeViewModel(listVm: listVm)

        //to have no spacing between sections
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    var body: some View {
        VStack {
            List {
                Section {
                    VStack (spacing: 20){
                        Text("Création recette").font(.system(size: 40)).bold().multilineTextAlignment(.center)
                        
                        VStack (spacing: 20){
                            VStack (spacing: 5) {
                                Text("Nom recette").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                                TextField("Nom recette", text: $createVm.nomRecette)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.pageElementBackground))
                                    .foregroundColor(Color.textFieldForeground)
                            }
                            
                            VStack (spacing: 5) {
                                Text("Nom auteur").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                                TextField("Nom auteur", text: $createVm.nomAuteur)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.pageElementBackground))
                                    .foregroundColor(Color.textFieldForeground)
                                    .disableAutocorrection(true)
                            }
                            
                            HStack (spacing: 20){
                                VStack (spacing: 5) {
                                    Text("Type repas").font(.title2)
                                    Picker("Type repas", selection: $createVm.mealType) {
                                        Text("Entrée").tag("Entrée")
                                        Text("Principal").tag("Principal")
                                        Text("Déssert").tag("Déssert")
                                    }
                                    .pickerStyle(.menu)
                                }
                                .frame(height: 100, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.pageElementBackground)
                                .cornerRadius(10)
                                
                                VStack (spacing: 5) {
                                    Text("N° Couverts").font(.title2)
                                    TextField("N° Couverts", value: $createVm.dishes, formatter: createVm.numberFormatter)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.pageInnerTextFieldBackground))
                                        .foregroundColor(Color.textFieldForeground)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                        .keyboardType(.numbersAndPunctuation)
                                        .onSubmit {
                                            createVm.creationIntent.intentToChange(dishes: createVm.dishes)
                                        }
                                }
                                .padding(15)
                                .frame(height: 100, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.pageElementBackground)
                                .cornerRadius(10)
                            }
                        }
                    }
                    .listRowBackground(Color.white.opacity(0))
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //new step button
                Section (header: Text("Etapes")
                            .font(.system(size: 30))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                            .padding(.bottom, 15)
                            .textCase(.none)
                            .foregroundColor(Color.textFieldForeground)) {
                    Button(action: {
                        createVm.newStepSheetIsOn.toggle()
                    }, label: {
                        HStack {
                            Image(systemName : "plus")
                                .font(.title2)
                            Text("Nouvelle étape")
                                .font(.title2)
                                .padding(.vertical, 12)
                        }
                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.blue)
                        .foregroundColor(.white)
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $createVm.newStepSheetIsOn) {
                            NewStepView(listVm : createVm)
                        }
                }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //steps list
                Section {
                    if createVm.etapes.isEmpty {
                        Text("Aucune étape")
                            .font(.system(size: 21))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .listRowBackground(Color.white.opacity(0))
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    }
                    else {
                        ForEach(createVm.etapes, id: \.id) {etape in
                            Button {
                                createVm.showStep.toggle()
                            } label : {
                                Text(etape.nomEtape!).font(.system(size: 21))
                                    .frame(height: 50).foregroundColor(.primary)
                            }
                            .sheet(isPresented: $createVm.showStep) {
                                if etape is InExtensoStep {
                                    InExtensoStepView(step: etape as! InExtensoStep)
                                }
                                else {
                                    RecipeView(recette: etape as! Recette, isSheet: true)
                                }
                                
                            }
                        }
                        .onDelete(perform: createVm.deleteStep)
                        .onMove(perform: createVm.moveStep)
                    }
                }
                
                
                //costs button
                Section {
                    Button(action: {
                        createVm.costsSheetIsOn.toggle()
                    }, label: {
                        HStack {
                            Text("Coûts")
                                .font(.title2)
                                .padding(.vertical, 12)
                        }
                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.blue)
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $createVm.costsSheetIsOn) {
                            CostsView()
                        }
                }
                .listRowBackground(Color.white.opacity(0))
                .padding(.top, 40)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //ingredients button
                Section {
                    Button(action: {
                        createVm.ingredientsSheetIsOn.toggle()
                    }, label: {
                        HStack {
                            Image(systemName: "cart")
                                .font(.title2)
                            Text("Tous les ingrédients")
                                .font(.title2)
                                .padding(.vertical, 12)
                        }
                    })
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                        .background(.blue)
                        .foregroundColor(.white)
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $createVm.ingredientsSheetIsOn) {
                            RecipeIngredientListView(steps: createVm.etapes)
                        }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //create button
                Section {
                    HStack (spacing: 20){
                        Button(action: {
                            if !createVm.nomRecette.isEmpty && !createVm.nomAuteur.isEmpty{
                                createVm.listIntent.intentToAdd(recette: Recette(nbCouverts: createVm.dishes, nomAuteur: createVm.nomAuteur, nomCatRecette: createVm.mealType, nomRecette: createVm.nomRecette, etapes: createVm.etapes))
                                presentationMode.wrappedValue.dismiss()
                            }
                            else {
                                createVm.showSubmitError.toggle()
                            }
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
                            .alert(isPresented: $createVm.showSubmitError) {
                                Alert (
                                    title: Text("Veuillez remplir tous les champs")
                                    )
                            }
                        
                        Button(action: {
                            //dismiss the current view
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
                    .listRowBackground(Color.white.opacity(0))
                }
                .listRowBackground(Color.white.opacity(0))
                .padding(.top, 40)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
            .toolbar {
                EditButton()
            }
        }
        .navigationBarBackButtonHidden(true)
    }
}

//struct CreateRecipeView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateRecipeView()
//    }
//}
