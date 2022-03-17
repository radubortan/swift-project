import SwiftUI

struct StocksListView: View {
    @ObservedObject var stockListViewModel = StockListViewModel()
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    List {
                        Section {
                            HStack(spacing: 15) {
                                Button (action: {
                                    withAnimation{stockListViewModel.showCategoryFilter.toggle()}
                                }, label: {
                                    Text("Catégorie").font(.system(size: 21))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                })
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .buttonStyle(BorderlessButtonStyle())
                                
                                Button (action: {
                                    withAnimation{stockListViewModel.showAllergenFilter.toggle()}
                                }, label: {
                                    Text("Allergène").font(.system(size: 21))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                })
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .buttonStyle(BorderlessButtonStyle())
                            }
                            .listRowBackground(Color.white.opacity(0))
                        }
                        .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        
                        Section {
                            if stockListViewModel.filterResults.count == 0{
                                Text("Aucune stock")
                                    .font(.system(size: 21))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .listRowBackground(Color.white.opacity(0))
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            ForEach(stockListViewModel.filterResults, id: \.self.id) {ingredient in
                                Button{
                                    stockListViewModel.showingSheet.toggle()
                                }
                                label : {
                                    HStack {
                                        Text(ingredient.nomIng).font(.system(size: 21)).truncationMode(.tail).foregroundColor(.primary)
                                        Spacer()
                                        if ingredient.nomCatAllerg != nil {
                                            Image(systemName: "exclamationmark.circle")
                                                .resizable()
                                                .frame(width: 25, height: 25)
                                                .foregroundColor(.red)
                                        }
                                        Text("\(String(format:"%.1f",ingredient.quantite)) \(ingredient.unite)")
                                            .frame(width: 75, height: 40)
                                            .background(Color.stockAmountBackground)
                                            .cornerRadius(10)
                                            .foregroundColor(Color.textFieldForeground)
                                    }.frame(height: 50)
                                }
                                .sheet(isPresented : $stockListViewModel.showingSheet) {
                                    StockView(stockViewModel: StockViewModel(ingredient: ingredient),stockListViewModel: self.stockListViewModel)
                                }
                            }
                        }
                    }
                    .searchable(text: $stockListViewModel.enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche ingrédient")
                    .navigationTitle("Stocks")
                }
                FilterMenu(title: "Catégorie", height: 250, isOn: $stockListViewModel.showCategoryFilter, filter: stockListViewModel.categoryFilters)
                FilterMenu(title: "Type Allergène", height: 250, isOn: $stockListViewModel.showAllergenFilter, filter: stockListViewModel.allergenFilters)
            }
            
        }
        .navigationViewStyle(StackNavigationViewStyle()) //to fix constraints error that appear in the console due to navigationTitle
    }
}
//
//struct StocksListView_Previews: PreviewProvider {
//    static var previews: some View {
//        StocksListView()
//    }
//}
