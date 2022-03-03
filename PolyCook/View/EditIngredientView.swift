import SwiftUI

struct EditIngredientView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var ingredientViewModel: IngredientViewModel
    @ObservedObject var editIngredientViewModel: EditIngredientViewModel
    var intentIngredient: IntentIngredient
    
    @State var selected : String = ""
    @State var selectedModel : String = "Kg"
    @State private var isAllergene : Bool = false
    
    @State var selectedAllergenCategory : String = "Crustacés"
    @State var selectedIngredientCategory : String = "Crustacés"
    
    @ObservedObject var ingredientCategoryList = IngredientCategories()
    @ObservedObject var allergenCategoryList = AllergenCategories()
    
    init(ingredientViewModel: IngredientViewModel, ingredientListViewModel: IngredientListViewModel){
        self.ingredientViewModel = ingredientViewModel
        
        self.editIngredientViewModel = EditIngredientViewModel(ingredient: ingredientViewModel.ingredient)


        self.intentIngredient = IntentIngredient()
        self.intentIngredient.addObserver(viewModel: ingredientViewModel)
        self.intentIngredient.addObserver(viewModel: ingredientListViewModel)
        
        self._selectedIngredientCategory = State(initialValue: self.editIngredientViewModel.nomCat)

        if let currentNomCatAllerg  = self.editIngredientViewModel.nomCatAllerg {
            self._isAllergene = State(initialValue: true)
            self._selectedAllergenCategory = State(initialValue: currentNomCatAllerg)
        }
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(10)
            
            Text("Modification").font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            VStack (spacing: 5) {
                Text("Nom ingrédient").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                TextField("Nom ingrédient", text: $editIngredientViewModel.nomIng)
                    .padding(10)
                    .background(RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.sheetElementBackground))
                    .foregroundColor(Color.textFieldForeground)
                if editIngredientViewModel.nomIngIsTooShort {
                    Text("Le nom doit comporter au moins 3 caractères")
                        .foregroundColor(.red)
                }
            }
            
            VStack (spacing: 5) {
                Text("Catégorie").font(.title2)
                Picker("Catégorie", selection: $selectedIngredientCategory) {
                    ForEach(Array(ingredientCategoryList), id: \.self.id) { ingredientCategory in
                        Text(ingredientCategory.nomCatIng).tag(ingredientCategory.nomCatIng)
                    }
                }
                .pickerStyle(.menu)
                .onChange(of: selectedIngredientCategory){ selectedIngredientCategory in
                    self.editIngredientViewModel.nomCat = selectedIngredientCategory
                }
            }
            .frame(height: 100, alignment: .center)
            .frame(maxWidth: .infinity)
            .background(Color.sheetElementBackground)
            .cornerRadius(10)
            
            VStack {
                Toggle("Allergène", isOn: $isAllergene).font(.title2).onChange(of: isAllergene){
                    newValue in
                    if(newValue){
                        editIngredientViewModel.nomCatAllerg = selectedAllergenCategory

                    }else{
                        editIngredientViewModel.nomCatAllerg = nil
                    }
                }
                
                if isAllergene {
                    VStack (spacing: 5) {
                        Text("Catégorie Allergène").font(.title2)
                        Picker("Catégorie Allergène", selection: $selectedAllergenCategory) {
                            ForEach(Array(allergenCategoryList), id: \.self.id) { allergenCategory in
                                Text(allergenCategory.nomCatAllerg).tag(allergenCategory.nomCatAllerg)
                            }
                        }
                        .pickerStyle(.menu)
                        .onChange(of: selectedAllergenCategory){ selectedAllergenCategory in
                            editIngredientViewModel.nomCatAllerg = selectedAllergenCategory
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
                    editIngredientViewModel.intentIngredientState.intentToChange(nomIng: editIngredientViewModel.nomIng)
                    if !editIngredientViewModel.nomIngIsTooShort{
                        editIngredientViewModel.ingredient.nomCat = editIngredientViewModel.nomCat
                        editIngredientViewModel.ingredient.nomCatAllerg = editIngredientViewModel.nomCatAllerg
                        intentIngredient.intentToEditIngredient(ingredient: editIngredientViewModel.ingredient)
                        presentationMode.wrappedValue.dismiss()
                    }
                    

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
        .background(Color.sheetBackground)
    }
}

//struct EditIngredientView_Previews: PreviewProvider {
//    static var previews: some View {
//        EditIngredientView()
//    }
//}
