//
//  IngredientListView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct IngredientListView: View {
    let ingredients = ["Poisson", "Tomate", "Pomme", "Chocolat", "Viande Boeuf", "Pates", "Oignon", "Pain", "Courgette"]
    
    @State private var enteredText : String = ""
    @State private var isOn = false
    
    @State var toBeDeleted : IndexSet?
    @State var showingDeleteAlert = false
    
    @State private var showingSheet = false
    
    func deleteRecipe(at indexSet : IndexSet) {
        self.toBeDeleted = indexSet
        self.showingDeleteAlert = true
    }
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    ForEach(searchResults, id: \.self) {ingredient in
                        //                        version sans flèche
                        ZStack {
                            NavigationLink(destination: IngredientView()) {
                                EmptyView()
                            }.opacity(0)
                            HStack {
                                Text(ingredient).font(.system(size: 21)).truncationMode(.tail)
                                Spacer()
                                Image(systemName: "exclamationmark.circle")
                                    .resizable()
                                    .frame(width: 25, height: 25)
                                    .foregroundColor(.red)
                            }.frame(height: 50)
                        }
                        
                        
                        
                        //version avec flèche
                        //                        NavigationLink(destination: RecipeView()) {
                        //                            HStack {
                        //                                Text(ingredient).font(.system(size: 21)).truncationMode(.tail)
                        //                                Spacer()
                        //                                Image(systemName: "exclamationmark.circle")
                        //                                    .resizable()
                        //                                    .frame(width: 25, height: 25)
                        //                                    .foregroundColor(.red)
                        //                                Text("10kg")
                        //                                    .padding(10)
                        //                                    .background(Color.stockAmountBackground)
                        //                                    .cornerRadius(10)
                        //                                    .foregroundColor(Color.textFieldForeground)
                        //                            }
                        //                        }.frame(height: 50)
                    }
                    .onDelete(perform: deleteRecipe)
                }
                .searchable(text: $enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche ingrédient")
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
                    CreateIngredientView()
                }
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) //to fix constraints error that appear in the console due to navigationTitle
    }
    
    var searchResults: [String] {
        if enteredText.isEmpty {
            return ingredients
        } else {
            //we need to filter using lowercased names
            return ingredients.filter { $0.lowercased().contains(enteredText.lowercased())}
        }
    }
}

struct IngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        IngredientListView()
    }
}
