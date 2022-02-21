//
//  StocksListView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct StocksListView: View {
    let ingredients = ["Poisson", "Tomate", "Pomme", "Chocolat", "Viande Boeuf", "Pates", "Oignon", "Pain", "Courgette"]
    
    @State private var enteredText : String = ""
    
    //filter states
    @State var showCategoryFilter = false
    @State var showAllergenFilter = false
    @State var categoryFilter = [FilterItem(title: "Crustacés"),FilterItem(title: "Crèmerie"),FilterItem(title: "Epicerie"),FilterItem(title: "Fruits"),FilterItem(title: "Légumes"),FilterItem(title: "Poisson"), FilterItem(title: "Viande"), FilterItem(title: "Volailles")]
    @State var allergenFilter = [FilterItem(title: "Arachide"),FilterItem(title: "Crustacés"),FilterItem(title: "Céléri"),FilterItem(title: "Fruits à coque"),FilterItem(title: "Lait"),FilterItem(title: "Lupin"), FilterItem(title: "Mollusques"), FilterItem(title: "Moutarde")]
    
    @State private var showingSheet = false
    
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
                            ForEach(searchResults, id: \.self) {ingredient in
                                Button{
                                    showingSheet.toggle()
                                }
                                label : {
                                    HStack {
                                        Text(ingredient).font(.system(size: 21)).truncationMode(.tail).foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "exclamationmark.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.red)
                                            Text("10kg")
                                                .padding(10)
                                                .background(Color.stockAmountBackground)
                                                .cornerRadius(10)
                                                .foregroundColor(Color.textFieldForeground)
                                    }.frame(height: 50)
                                }
                                .sheet(isPresented : $showingSheet) {
                                    StockView()
                                }
                            }
                        }
                    }
                    .searchable(text: $enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche ingrédient")
                    .navigationTitle("Stocks")
                }
                FilterMenu(title: "Catégorie", height: 250, isOn: $showCategoryFilter, filters: $categoryFilter)
                FilterMenu(title: "Type Allergène", height: 250, isOn: $showAllergenFilter, filters: $allergenFilter)
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

struct StocksListView_Previews: PreviewProvider {
    static var previews: some View {
        StocksListView()
    }
}
