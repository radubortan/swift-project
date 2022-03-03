import SwiftUI

struct StocksListView: View {
    let ingredients = ["Poisson", "Tomate", "Pomme", "Chocolat", "Viande Boeuf", "Pates", "Oignon", "Pain", "Courgette"]
    
    @State private var enteredText : String = ""
    
    @ObservedObject var stockListViewModel = StockListViewModel()
    
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
                                Button (action: {
                                    withAnimation{showCategoryFilter.toggle()}
                                }, label: {
                                    Text("Catégorie").font(.system(size: 21))
                                })
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .buttonStyle(BorderlessButtonStyle())
                                
                                Button (action: {
                                    withAnimation{showAllergenFilter.toggle()}
                                }, label: {
                                    Text("Allergène").font(.system(size: 21))
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
                            if searchResults.count == 0{
                                Text("Aucune stock")
                                    .font(.system(size: 21))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .listRowBackground(Color.white.opacity(0))
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            ForEach(searchResults, id: \.self.id) {ingredient in
                                Button{
                                    showingSheet.toggle()
                                }
                                label : {
                                    HStack {
                                        Text(ingredient.nomIng).font(.system(size: 21)).truncationMode(.tail).foregroundColor(.primary)
                                        Spacer()
                                        Image(systemName: "exclamationmark.circle")
                                            .resizable()
                                            .frame(width: 25, height: 25)
                                            .foregroundColor(.red)
                                        Text("\(ingredient.quantite) \(ingredient.unite)")
                                            .padding(10)
                                            .background(Color.stockAmountBackground)
                                            .cornerRadius(10)
                                            .foregroundColor(Color.textFieldForeground)
                                    }.frame(height: 50)
                                }
                                .sheet(isPresented : $showingSheet) {
                                    StockView(stockViewModel: StockViewModel(ingredient: ingredient),stockListViewModel: self.stockListViewModel)
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
    
    var searchResults: [Ingredient] {
        if enteredText.isEmpty {
            return self.stockListViewModel.stocks
        } else {
            //we need to filter using lowercased names
            return self.stockListViewModel.stocks.filter { $0.nomIng.lowercased().contains(enteredText.lowercased())}
        }
    }
}

struct StocksListView_Previews: PreviewProvider {
    static var previews: some View {
        StocksListView()
    }
}
