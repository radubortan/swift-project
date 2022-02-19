//
//  ContentView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct RecipeListView: View {
    let recipes = ["Steak frites", "Mousse au chocolat", "Boeuf bourgignon", "Ratatouille", "Pates carbonara", "Omelette", "Oeufs mimosa", "Tarte thon", "Coquilles St. Jacques", "Velouté de potiron", "Soupe à l'oignon", "Salade César", "Oeufs cocottes", "Quiche aux poireaux", "Nems de figatelli", "Bruschetta"]
    @State private var enteredText : String = ""
    @State private var isOn = false
    
    @State var toBeDeleted : IndexSet?
    @State var showingDeleteAlert = false
    
    @EnvironmentObject var loginVM : LoginViewModel
    
    func deleteRecipe(at indexSet : IndexSet) {
        self.toBeDeleted = indexSet
        self.showingDeleteAlert = true
    }
    
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach(searchResults, id: \.self) {recipe in
                        NavigationLink(destination: RecipeView()) {
                            HStack {
                                Text(recipe)
                                Spacer()
                                Image(systemName: "exclamationmark.circle").foregroundColor(.red)
                            }
                        }
//                        .alert(isPresented: self.$showingDeleteAlert) {
//                            Alert(title: Text("..."), message: Text("Etes vous sûr de vouloir supprimer la recette?"), primaryButton: .destructive(Text("Supprimer")) {
//                                for index in self.toBeDeleted! {
//                                    let item = searchResults[index]
//                                    viewContext.delete(item)
//                                    do {
//                                        try viewContext.save()
//                                    }
//                                    catch let error {
//                                        print("Error: \(error)")
//                                    }
//                                }
//                                self.toBeDeleted = nil
//                            }, secondaryButton: .cancel(Text("Annuler")) {
//                                self.toBeDeleted = nil
//                            })
//                        }
                    }
                    .onDelete(perform: deleteRecipe)
                    .deleteDisabled(!loginVM.isSignedIn)
                }
                .searchable(text: $enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche recette")
                .navigationTitle("Recettes")
                .toolbar {
                    ToolbarItem(placement: .navigationBarTrailing) {
                    if loginVM.signedIn {
                        
                            Button{} label: {
                                Image(systemName: "plus")
                            }
                        }
                    }
                }
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
