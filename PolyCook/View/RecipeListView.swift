import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var loginVM : LoginViewModel
    
    @ObservedObject var listVm = RecipeListViewModel()
    @ObservedObject var mealFilters = Filter(filters: [FilterItem(title: "Entrée"), FilterItem(title: "Principal"), FilterItem(title: "Dessert")])
    @ObservedObject var ingredientFilters = Filter(filters: [FilterItem(title: "Pomme"), FilterItem(title: "Oeuf"), FilterItem(title: "Pâtes"), FilterItem(title: "Poisson"), FilterItem(title: "Tomate"), FilterItem(title: "Oignon"), FilterItem(title: "Courgette")])
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    List {
                        Section {
                            HStack(spacing: 15) {
                                Button (action: {
                                    withAnimation{listVm.showMealFilter.toggle()}
                                }, label: {
                                    Text("Type Repas").font(.system(size: 21))
                                })
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .buttonStyle(BorderlessButtonStyle())
                                
                                Button (action: {
                                    withAnimation{listVm.showIngredientFilter.toggle()}
                                }, label: {
                                    Text("Ingrédients").font(.system(size: 21))
                                })
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                            .listRowBackground(Color.white.opacity(0))
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Section {
                            if searchResults.isEmpty {
                                Text("Aucune recette")
                                    .font(.system(size: 21))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .listRowBackground(Color.white.opacity(0))
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            else {
                                ForEach(searchResults, id: \.id) {recette in
                                    ZStack {
                                        NavigationLink(destination: RecipeView(recette: recette, isSheet: false)) {
                                            EmptyView()
                                        }.opacity(0)
                                        HStack {
                                            Text(recette.nomRecette).font(.system(size: 21)).truncationMode(.tail)
                                            Spacer()
                                            if recette.hasAllergens {
                                                Image(systemName: "exclamationmark.circle")
                                                    .resizable()
                                                    .frame(width: 25, height: 25)
                                                    .foregroundColor(.red)
                                            }
                                        }.frame(height: 50)
                                    }
                                }
                                .onDelete(perform: listVm.showConfirmation)
                                .confirmationDialog(
                                    "Voulez vous supprimer la recette?",
                                    isPresented : $listVm.showingDeleteAlert,
                                    titleVisibility: .visible
                                ) {
                                    Button("Oui") {
                                        withAnimation {
                                            listVm.remove(atOffsets: self.listVm.toBeDeleted!)
                                        }
                                    }
                                    Button("Non", role: .cancel) {}
                                }
                                .deleteDisabled(!loginVM.isSignedIn)
                            }
                            
                        }
                    }
                    .searchable(text: $listVm.enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche recette")
                    .navigationTitle("Recettes")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if loginVM.signedIn {
                                Button{} label: {
                                    NavigationLink(destination: CreateRecipeView(listVm : self.listVm, recipes: listVm.recipes)){
                                        Image(systemName: "text.badge.plus")
                                    }
                                }
                            }
                        }
                    }
                }
                FilterMenu(title: "Type Repas", height: 125, isOn: $listVm.showMealFilter, filter: mealFilters)
                FilterMenu(title: "Ingrédients", height: 250, isOn: $listVm.showIngredientFilter, filter: ingredientFilters)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) //to fix constraints error that appear in the console due to navigationTitle
    }
    
    var searchResults: [Recette] {
        var checkedMealTypes : [String] = []
        for filter in mealFilters.filters {
            if filter.checked {
                checkedMealTypes.append(filter.title)
            }
        }
        
        if listVm.enteredText.isEmpty {
            var finalResult : [Recette] = []
            for recipe in listVm.recipes {
                if checkedMealTypes.isEmpty {
                    return listVm.recipes
                }
                else {
                    if checkedMealTypes.contains(recipe.nomCatRecette) {
                        finalResult.append(recipe)
                    }
                }
            }
            return finalResult
        }
        else {
            //we need to filter using lowercased names
            let filteredBySearchBar = listVm.recipes.filter { $0.nomRecette.lowercased().contains(listVm.enteredText.lowercased())}
            
            var finalResult : [Recette] = []
            for recipe in filteredBySearchBar {
                if checkedMealTypes.isEmpty {
                    return filteredBySearchBar
                }
                else {
                    if checkedMealTypes.contains(recipe.nomCatRecette) {
                        finalResult.append(recipe)
                    }
                }
            }
            return finalResult
            
//            return listVm.recipes.filter { $0.nomRecette.lowercased().contains(listVm.enteredText.lowercased())}
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
