import SwiftUI

struct CreateRecipeView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @State var mealType : String = "Entrée"
    @State var nomRecette : String = ""
    @State var nomAuteur : String = ""
    @State var dishes : Int = 1
    
    @State var newStepSheetIsOn = false
    @State var costsSheetIsOn = false
    @State var ingredientsSheetIsOn = false
    @State var showStep = false
    
    //formats the entered values
    let numberFormatter = NumberFormatter()
    
    func deletion(at indexSet: IndexSet) {
        
    }
    
    let etapes = ["etape 1", "etape 2", "etape 3", "etape 4"]
    
    func fonctionProvisoire(at indexSet : IndexSet) {
        
    }
    
    init() {
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
                                TextField("Nom recette", text: $nomRecette)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.pageElementBackground))
                                    .foregroundColor(Color.textFieldForeground)
                            }
                            
                            VStack (spacing: 5) {
                                Text("Nom auteur").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                                TextField("Nom auteur", text: $nomAuteur)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.pageElementBackground))
                                    .foregroundColor(Color.textFieldForeground)
                                    .disableAutocorrection(true)
                            }
                            
                            HStack (spacing: 20){
                                VStack (spacing: 5) {
                                    Text("Type repas").font(.title2)
                                    Picker("Type repas", selection: $mealType) {
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
                                    TextField("N° Couverts", value: $dishes, formatter: numberFormatter)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.pageInnerTextFieldBackground))
                                        .foregroundColor(Color.textFieldForeground)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                        .keyboardType(.numbersAndPunctuation)
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
                        newStepSheetIsOn.toggle()
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
                        .sheet(isPresented: $newStepSheetIsOn) {
                            NewStepView()
                        }
                }
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //steps list
                Section {
                    ForEach(etapes, id: \.self) {etape in
                        //                        Text(etape).font(.system(size: 21))
                        //                            .frame(height: 50)
                        Button {
                            showStep.toggle()
                        } label : {
                            Text(etape).font(.system(size: 21))
                                .frame(height: 50).foregroundColor(.primary)
                        }
                        .sheet(isPresented: $showStep) {
                            InExtensoStepView()
                        }
                    }
                    .onDelete(perform: fonctionProvisoire)
                    .onMove { indexSet, index in
                    }
                }
                
                
                //costs button
                Section {
                    Button(action: {
                        costsSheetIsOn.toggle()
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
                        .sheet(isPresented: $costsSheetIsOn) {
                            CostsView()
                        }
                }
                .listRowBackground(Color.white.opacity(0))
                .padding(.top, 40)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //ingredients button
                Section {
                    Button(action: {
                        ingredientsSheetIsOn.toggle()
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
                        .sheet(isPresented: $ingredientsSheetIsOn) {
                            RecipeIngredientListView()
                        }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //create button
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

struct CreateRecipeView_Previews: PreviewProvider {
    static var previews: some View {
        CreateRecipeView()
    }
}
