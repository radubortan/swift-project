//
//  ContentView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct RecipeListView: View {
    @EnvironmentObject var loginVM : LoginViewModel
    
    let recipes = ["Steak frites", "Mousse au chocolat", "Boeuf bourgignon", "Ratatouille", "Pates carbonara", "Omelette", "Oeufs mimosa", "Tarte thon", "Coquilles St. Jacques", "Velouté de potiron", "Soupe à l'oignon", "Salade César", "Oeufs cocottes", "Quiche aux poireaux", "Nems de figatelli", "Bruschetta"]
    @State private var enteredText : String = ""
    
    @State var toBeDeleted : IndexSet?
    @State var showingDeleteAlert = false
    
    //filter states
    @State var showMealFilter = false
    @State var showIngredientFilter = false
    @State var mealFilters = [FilterItem(title: "Entrée"), FilterItem(title: "Principal"), FilterItem(title: "Dessert")]
    @State var ingredientFilters = [FilterItem(title: "Pomme"), FilterItem(title: "Oeuf"), FilterItem(title: "Pâtes"), FilterItem(title: "Poisson"), FilterItem(title: "Tomate"), FilterItem(title: "Oignon"), FilterItem(title: "Courgette")]
    
    
    func deleteRecipe(at indexSet : IndexSet) {
        self.toBeDeleted = indexSet
        self.showingDeleteAlert = true
    }
    
    func showConfirmation(at indexSet : IndexSet) {
        self.toBeDeleted = indexSet
        self.showingDeleteAlert = true
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    List {
                        Section {
                            HStack(spacing: 15) {
                                Button ("Type Repas"){
                                    withAnimation{showMealFilter.toggle()}
                                }
                                .frame(maxWidth: .infinity, maxHeight: .infinity)
                                .background(.blue)
                                .foregroundColor(.white)
                                .cornerRadius(10)
                                .buttonStyle(BorderlessButtonStyle())
                                
                                Button ("Ingrédients"){
                                    withAnimation{showIngredientFilter.toggle()}
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
                            ForEach(searchResults, id: \.self) {recipe in
                                ZStack {
                                    NavigationLink(destination: RecipeView()) {
                                        EmptyView()
                                    }.opacity(0)
                                    HStack {
                                        Text(recipe).font(.system(size: 21)).truncationMode(.tail)
                                        Spacer()
                                        Image(systemName: "exclamationmark.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.red)
                                    }.frame(height: 50)
                                }
                            }
                            .onDelete(perform: showConfirmation)
                            .confirmationDialog(
                                "Voulez vous supprimer la recette?",
                                isPresented : $showingDeleteAlert,
                                titleVisibility: .visible
                            ) {
                                Button("Oui") {
                                    withAnimation {
                                        for index in self.toBeDeleted! {
                                            let item = searchResults[index]
    //                                        viewContext.delete(item)
                                            do {
    //                                            try viewContext.save()
                                            }
                                            catch let error {
                                                print("Error: \(error)")
                                            }
                                        }
                                    }
                                }
                                Button("Non", role: .cancel) {}
                            }
                            .deleteDisabled(!loginVM.isSignedIn)
                        }
                    }
                    .searchable(text: $enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche recette")
                    .navigationTitle("Recettes")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            if loginVM.signedIn {
                                Button{} label: {
                                    NavigationLink(destination: RecipeView()){
                                        Image(systemName: "plus")
                                    }
                                }
                            }
                        }
                    }
                }
                FilterMenu(title: "Type Repas", height: 125, isOn: $showMealFilter, filters: $mealFilters)
                FilterMenu(title: "Ingrédients", height: 250, isOn: $showIngredientFilter, filters: $ingredientFilters)
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) //to fix constraints error that appear in the console due to navigationTitle
    }
    
    var searchResults: [String] {
        if enteredText.isEmpty {
            return recipes
        } else {
            //we need to filter using lowercased names
            return recipes.filter { $0.lowercased().contains(enteredText.lowercased())}
        }
    }
}

struct RecipeListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeListView()
    }
}
