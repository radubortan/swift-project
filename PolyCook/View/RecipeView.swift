import SwiftUI

struct RecipeView: View {
    let etapes = ["etape 1", "etape 2", "etape 3", "etape 4"]
    let isSheet : Bool
    
    @State var costsSheetIsOn = false
    @State var ingredientsSheetIsOn = false
    @State var withCosts = false
    @State var quantity = 1
    @State var showStep = false
    
    //formats the entered values
    let numberFormatter = NumberFormatter()
    
    init(isSheet: Bool) {
        self.isSheet = isSheet
        //to have no spacing between sections
        UITableView.appearance().sectionFooterHeight = 0
    }
    
    var body: some View {
        VStack (spacing: 20) {
            if isSheet {
                Capsule()
                    .fill(Color.secondary)
                    .frame(width: 35, height: 5)
                    .padding(.top, 10)
                    .background(Color.sheetBackground)
            }
            
            List {
                Section {
                    Text("Mousse au chocolat").font(.system(size: 40)).bold().frame(maxWidth: .infinity, alignment: .center).multilineTextAlignment(.center)
                }
                .listRowBackground(Color.white.opacity(0))
                
                Section {
                    VStack (spacing: 20) {
                        VStack {
                            Text("Auteur(e) du plat: ").font(.title2).frame(maxWidth: .infinity, alignment: .center)
                            Divider()
                            Text("Radu Bortan").font(.title2).frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(15)
                        .frame(height: 110, alignment: .center)
                        .frame(maxWidth: .infinity)
                        .background(isSheet ? Color.sheetElementBackground : Color.pageElementBackground)
                        .cornerRadius(10)
                        
                        HStack (spacing: 20) {
                            VStack (spacing: 10) {
                                Text("Catégorie recette")
                                    .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                Divider()
                                Text("Déssert")
                                    .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .frame(height: 130)
                            .background(isSheet ? Color.sheetElementBackground : Color.pageElementBackground)
                            .cornerRadius(10)
                            
                            VStack (spacing: 10) {
                                Text("N°        couverts")
                                    .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                Divider()
                                Text("1")
                                    .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(15)
                            .frame(maxWidth: .infinity)
                            .frame(height: 130)
                            .background(isSheet ? Color.sheetElementBackground : Color.pageElementBackground)
                            .cornerRadius(10)
                        }
                        
                    }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.white.opacity(0))
                
                Section (header: Text("Etapes")
                            .font(.system(size: 30))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 40)
                            .padding(.bottom, 5)
                            .textCase(.none)
                            .foregroundColor(Color.textFieldForeground)) {
                    ForEach(etapes, id: \.self) {etape in
                        Button {
                            showStep.toggle()
                        } label : {
                            Text(etape).font(.system(size: 21))
                                .frame(height: 50).foregroundColor(.primary)
                        }
                        .sheet(isPresented: $showStep) {
                            RecipeView(isSheet : true)
                        }
                    }
                }
                
                VStack (spacing: 20) {
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
                        .cornerRadius(10)
                        .foregroundColor(.white)
                        .buttonStyle(BorderlessButtonStyle())
                        .sheet(isPresented: $ingredientsSheetIsOn) {
                            RecipeIngredientListView()
                        }
                }
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                .listRowBackground(Color.white.opacity(0))
                .padding(.top, 40)
                
                Section (header: Text("Fiche technique")
                            .font(.system(size: 30))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 60)
                            .padding(.bottom, 15)
                            .textCase(.none)
                            .foregroundColor(Color.textFieldForeground)) {
                    VStack (spacing: 20){
                        HStack (spacing: 20) {
                            VStack (spacing: 5) {
                                Text("N° Couverts").font(.title2)
                                TextField("N° Couverts", value: $quantity, formatter: numberFormatter)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(isSheet ? Color.innerTextFieldBackground : Color.pageInnerTextFieldBackground))
                                    .foregroundColor(Color.textFieldForeground)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .keyboardType(.numbersAndPunctuation)
                            }
                            .padding(15)
                            .frame(height: 100, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(isSheet ? Color.sheetElementBackground : Color.pageElementBackground)
                            .cornerRadius(10)
                            
                            VStack (spacing: 10) {
                                Text("Avec côuts")
                                    .font(.title2)
                                    .multilineTextAlignment(.center)
                                Toggle("", isOn: $withCosts).labelsHidden()
                            }
                            .frame(height: 100, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(isSheet ? Color.sheetElementBackground : Color.pageElementBackground)
                            .cornerRadius(10)
                        }
                        
                        Button(action: {
                            //impression
                        }, label: {
                            HStack {
                                Image(systemName: "printer")
                                    .font(.title2)
                                Text("Générer PDF")
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
                }
                            .listRowBackground(Color.white.opacity(0))
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            }
        }
        .background(Color.sheetBackground)
    }
}

struct RecipeView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeView(isSheet: true)
    }
}
