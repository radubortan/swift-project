import SwiftUI

struct CreateIngredientView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var addIngredientViewModel : AddIngredientViewModel
    @ObservedObject var ingredientCategoryList = IngredientCategories()
    @ObservedObject var allergenCategoryList = AllergenCategories()
    @ObservedObject var uniteList = Unites()
    
    var intentIngredient: IntentIngredient
    
    init(ingredientListViewModel: IngredientListViewModel, ingredient : Ingredient){
        self.addIngredientViewModel = AddIngredientViewModel(ingredient: ingredient)
        self.intentIngredient = IntentIngredient()
        self.intentIngredient.addObserver(viewModel: ingredientListViewModel)
        self.addIngredientViewModel.nomCat = addIngredientViewModel.selectedIngredientCategory
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(10)
            
            Text("Création Ingrédient").font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            VStack (spacing: 5) {
                Text("Nom ingrédient").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                TextField("Nom ingrédient", text: $addIngredientViewModel.nomIng)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.sheetElementBackground))
                    .foregroundColor(Color.textFieldForeground)
                    .onChange(of: addIngredientViewModel.nomIng, perform: { newNomIng in
//                        addIngredientViewModel.intentIngredientState.intentToChange(nomIng:newNomIng)
                    })
            }
            if addIngredientViewModel.nomIngIsTooShort {
                Text("Le nom doit comporter au moins 3 caractères")
                    .foregroundColor(.red)
            }
            
            HStack (spacing: 20){
                VStack (spacing: 5) {
                    Text("Unité").font(.title2)
                    Picker("Catégorie", selection: $addIngredientViewModel.selectedUnite) {
                        ForEach(Array(uniteList), id: \.self.id) { unite in
                            Text(unite.nomUnite).tag(unite.nomUnite)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: addIngredientViewModel.selectedUnite){ selectedUnite in
                        self.addIngredientViewModel.unite = selectedUnite
                    }
                }
                .frame(height: 100, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
                
                VStack (spacing: 5) {
                    Text("Catégorie").font(.title2)
                    Picker("Catégorie", selection: $addIngredientViewModel.selectedIngredientCategory) {
                        ForEach(Array(ingredientCategoryList), id: \.self.id) { ingredientCategory in
                            Text(ingredientCategory.nomCatIng).tag(ingredientCategory.nomCatIng)
                        }
                    }
                    .pickerStyle(.menu)
                    .onChange(of: addIngredientViewModel.selectedIngredientCategory){ selectedIngredientCategory in
                        self.addIngredientViewModel.nomCat = selectedIngredientCategory
                    }
                }
                .frame(height: 100, alignment: .center)
                .frame(maxWidth: .infinity)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
            }
            
            VStack {
                Toggle("Allergène", isOn: $addIngredientViewModel.isAllergene).font(.title2).onChange(of: addIngredientViewModel.isAllergene){
                    newValue in
                    if(newValue){
                        self.addIngredientViewModel.nomCatAllerg = addIngredientViewModel.selectedAllergenCategory

                    }else{
                        self.addIngredientViewModel.nomCatAllerg = nil
                    }
                }
                
                if addIngredientViewModel.isAllergene {
                    VStack (spacing: 5) {
                        Text("Catégorie Allergène").font(.title2)
                        Picker("Catégorie Allergène", selection: $addIngredientViewModel.selectedAllergenCategory) {
                            ForEach(Array(allergenCategoryList), id: \.self.id) { allergenCategory in
                                Text(allergenCategory.nomCatAllerg)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: addIngredientViewModel.selectedAllergenCategory){ selectedAllergenCategory in
                            self.addIngredientViewModel.nomCatAllerg = selectedAllergenCategory
                        }
                    }
                    .frame(height: 100, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .background(Color.sheetElementBackground)
                    .cornerRadius(10)
                }
            }
            
            HStack (spacing: 20){
                Button(action: {
                    //sauvegarder
                    addIngredientViewModel.intentIngredientState.intentToChange(nomIng:addIngredientViewModel.nomIng)

                    if !addIngredientViewModel.nomIngIsTooShort{
                        intentIngredient.intentToAddIngredient(ingredient: addIngredientViewModel.ingredient)
                        presentationMode.wrappedValue.dismiss()
                    }
                }, label: {
                    Text("Créer")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                }).background(.blue).cornerRadius(10)
                
                Button(action: {
                    //dismissed the current view
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Annuler")
                        .font(.title2)
                        .foregroundColor(.white)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                }).background(.red).cornerRadius(10)
            }
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .background(Color.sheetBackground)
        .navigationBarTitle("")
        .navigationBarHidden(true)
    }
}

//struct CreateIngredientView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateIngredientView()
//    }
//}
