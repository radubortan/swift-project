import SwiftUI

struct StockView: View {
    
    @ObservedObject var stockViewModel: StockViewModel
    @ObservedObject var stockListViewModel: StockListViewModel
    
    var body: some View {
        VStack (spacing: 20){
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(10)
            
            Text(stockViewModel.nomIng).font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            HStack (spacing: 20){
                VStack (spacing: 10){
                    Text("Prix unitaire")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(String(format: "%.2f€", stockViewModel.prixUnitaire))
                        .font(.system(size: stockViewModel.smallText)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
                
                VStack (spacing: 10) {
                    Text("Unité")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(stockViewModel.unite)
                        .font(.system(size: stockViewModel.smallText)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
            }
            
            HStack (spacing: 20) {
                VStack (spacing: 10) {
                    Text("Catégorie")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(stockViewModel.nomCat)
                        .font(.system(size: stockViewModel.smallText)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
                
                VStack (spacing: 10) {
                    Text("Quantité")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("\(String(format: "%.1f", stockViewModel.quantite))")
                        .font(.system(size: stockViewModel.smallText)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
            }
            
            if let allergen = stockViewModel.nomCatAllerg {
                VStack (spacing: 10) {
                    Text("Catégorie d'allergène")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                    Text(allergen)
                        .font(.system(size: stockViewModel.smallText)).frame(maxWidth: .infinity, alignment: .center)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
            }
            
            
            Button(action: {
                stockViewModel.showingSheet.toggle()
            }, label: {
                Text("Modifier Stock")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .frame(maxWidth: .infinity)
            }).background(.blue).cornerRadius(10)
                .sheet(isPresented : $stockViewModel.showingSheet) {
                    ModifyStockView(modifyStockViewModel: ModifyStockViewModel(ingredient: stockViewModel.ingredient),stockListViewModel: self.stockListViewModel,stockViewModel: self.stockViewModel)
                }
            
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .background(Color.sheetBackground)
    }
}

//struct StockView_Previews: PreviewProvider {
//    static var previews: some View {
//        StockView()
//            .preferredColorScheme(.dark)
//    }
//}
