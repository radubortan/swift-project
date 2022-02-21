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
    @State private var isOn = false
    
    @State private var showingSheet = false
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    Section {
                        HStack() {
                            Button ("Catégorie"){}
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            .background(.blue)
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .buttonStyle(BorderlessButtonStyle())
                            
                            Button ("Allergène"){}
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
                            //version sans flèche
                            //                        ZStack {
                            //                            NavigationLink(destination: RecipeView()) {
                            //                                    EmptyView()
                            //                                }.opacity(0)
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
                            //                            }.frame(height: 50)
                            //                        }
                            
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
    //                                HStack (spacing: 5){
    //                                    Button {
    //
    //                                    } label: {
    //                                        Image(systemName: "minus.circle.fill").resizable().frame(width: 25, height: 25)
    //                                    }
                                        Text("10kg")
                                            .padding(10)
                                            .background(Color.stockAmountBackground)
                                            .cornerRadius(10)
                                            .foregroundColor(Color.textFieldForeground)
    //                                    Button {
    //
    //                                    } label: {
    //                                        Image(systemName: "plus.circle.fill").resizable().frame(width: 25, height: 25)
    //                                    }
    //                                }
                                    
                                }.frame(height: 50)
                            }
                            .sheet(isPresented : $showingSheet) {
                                StockView()
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
    //                    .listRowInsets(.init(top: 6, leading: 20, bottom: 6, trailing: 10))
                    }
                }
                .searchable(text: $enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche ingrédient")
                .navigationTitle("Stocks")
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
