//
//  IngredientListView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct IngredientListView: View {
    @ObservedObject var ingredientListViewModel = IngredientListViewModel()
    var intentIngredient: IntentIngredient
    
    
    @State private var enteredText : String = ""
    
    @State var toBeDeleted : IndexSet?
    @State var showingDeleteAlert = false
    
    //filter states
    @State var showCategoryFilter = false
    @State var showAllergenFilter = false
    @ObservedObject var ingredientCategories = IngredientCategories()
    @ObservedObject var allergenCategories = AllergenCategories()
    
    @State private var showingSheet = false
    

    init(){
        self.intentIngredient = IntentIngredient()
        self.intentIngredient.addObserver(viewModel: ingredientListViewModel)

    }
    
    func deleteIngredient(at offsets: IndexSet) {
        ingredientListViewModel.remove(atOffsets: offsets)
//        self.ingredientListViewModel.deleteIngredient(ingredient: ingredient)
//        self.showingDeleteAlert = true
    }
    
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    List {
                        Section {
                            HStack(spacing: 15) {
                                Button ("Catégorie"){
                                    withAnimation{showCategoryFilter.toggle()}
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Button ("Allergène"){
                                    withAnimation{showAllergenFilter.toggle()}
                                }
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
                            ForEach(ingredientListViewModel.ingredientsFiltered, id: \.self.id) {ingredient in
                                ZStack {
                                    NavigationLink(destination: IngredientView(ingredientViewModel: IngredientViewModel(ingredient: ingredient), ingredientListViewModel: self.ingredientListViewModel)) {
                                        EmptyView()
                                    }.opacity(0)
                                    HStack {
                                        Text(ingredient.nomIng).font(.system(size: 21)).truncationMode(.tail)
                                        Spacer()
                                        Image(systemName: "exclamationmark.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.red)
                                    }.frame(height: 50)
                                }
                            }
                            .onDelete {
                                self.deleteIngredient(at: $0)
                            }
                        }
                    }
                    .searchable(text: $enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche ingrédient").onChange(of: enteredText, perform: { newValue in
                        ingredientListViewModel.filteringOptions.patternToMatch = newValue
                        ingredientListViewModel.filterIngredients()
                        
                    })
                    .navigationTitle("Ingrédients")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button{
                                showingSheet.toggle()
                            } label: {
                                    Image(systemName: "plus")
                            }
                        }
                    }
                    .sheet(isPresented : $showingSheet) {
                        CreateIngredientView(ingredientListViewModel: self.ingredientListViewModel,ingredient:Ingredient(id: UUID().uuidString, nomIng: "",nomCat:"Crustacés", nomCatAllerg: nil, unite: "Kg"))
                    }
                }
                FilterMenu(title: "Catégorie", height: 250, isOn: $showCategoryFilter, filters: $ingredientCategories.ingredientCategoryFilter)
                FilterMenu(title: "Type Allergène", height: 250, isOn: $showAllergenFilter, filters: $allergenCategories.allergenCategoryFilter)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) //to fix constraints error that appear in the console due to navigationTitle
    }
    
    var searchResults: [Ingredient] {
        var ingredientsFiltered = ingredientListViewModel.ingredients
        if !enteredText.isEmpty {
            ingredientsFiltered = ingredientsFiltered.filter { $0.nomIng.lowercased().contains(enteredText.lowercased())
            }
        }
            //we need to filter using lowercased names

        if !ingredientCategories.hasNoCheckedFilter {
            ingredientsFiltered = ingredientsFiltered.filter {
                print($0.nomCat)
                return ingredientCategories.nomCatIsChecked(nomCat: $0.nomCat)
            }
        }
        
        print(ingredientsFiltered)
        return ingredientsFiltered
    
}
}

//struct IngredientListView_Previews: PreviewProvider {
//    static var previews: some View {
////        IngredientListView()
//    }
//}
