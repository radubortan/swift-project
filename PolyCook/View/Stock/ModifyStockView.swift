import SwiftUI

struct ModifyStockView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var modifyStockViewModel: ModifyStockViewModel
    
    var intentStock: IntentStock
    
    init(modifyStockViewModel: ModifyStockViewModel,stockListViewModel: StockListViewModel,stockViewModel: StockViewModel){
        self.modifyStockViewModel = modifyStockViewModel
        self.intentStock = IntentStock()
        self.intentStock.addObserver(viewModel: stockListViewModel)
        self.intentStock.addObserver(viewModel: stockViewModel)
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(10)
            
            Text(modifyStockViewModel.nomIng).font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            HStack {
                Text("Enlever")
                Toggle("", isOn: $modifyStockViewModel.isAdding.animation(.linear(duration: 0.3))).labelsHidden()
                Text("Ajouter")
            }
            
            HStack (spacing: 20) {
                VStack (spacing: 10) {
                    Text("Quantité actuelle")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("\(String(format: "%.1f", modifyStockViewModel.quantite)) \(modifyStockViewModel.unite)")
                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
                
                VStack (spacing: 10) {
                    Text("Nouvelle quantité")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("\(String(format: "%.1f", modifyStockViewModel.quantite + (modifyStockViewModel.isAdding ? modifyStockViewModel.quantityToAdd :  -modifyStockViewModel.quantityToRemove))) \(modifyStockViewModel.unite)")
                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 130)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
            }
            
            if modifyStockViewModel.isAdding {
                VStack (spacing: 5) {
                    Text("Augmentation (\(modifyStockViewModel.unite))").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                    TextField("Augmentation (\(modifyStockViewModel.unite))", value: $modifyStockViewModel.quantityToAdd, formatter: modifyStockViewModel.numberFormatter)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.sheetElementBackground))
                        .foregroundColor(Color.textFieldForeground)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.numbersAndPunctuation)
                    
                }
                
                VStack (spacing: 5) {
                    Text("Coût d'achat total (€)").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                    TextField("Coût d'achat total (€)", value: $modifyStockViewModel.totalPriceOfAddedQuantity, formatter: modifyStockViewModel.numberFormatter)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.sheetElementBackground))
                        .foregroundColor(Color.textFieldForeground)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.numbersAndPunctuation)
                }
            }
            else {
                VStack (spacing: 5) {
                    Text("Diminution (\(modifyStockViewModel.unite))").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                    TextField("Diminution (\(modifyStockViewModel.unite))", value: $modifyStockViewModel.quantityToRemove, formatter: modifyStockViewModel.numberFormatter)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.sheetElementBackground))
                        .foregroundColor(Color.textFieldForeground)
                        .disableAutocorrection(true)
                        .autocapitalization(.none)
                        .keyboardType(.numbersAndPunctuation)
                }
            }
            
            HStack (spacing: 20){
                Button(action: {
                    //sauvegarder
                    if(modifyStockViewModel.isAdding){
                        intentStock.intentToIncreaseStock(quantityToBeAdded: modifyStockViewModel.quantityToAdd, totalPriceOfQuantityAdded: modifyStockViewModel.totalPriceOfAddedQuantity)
                        intentStock.intentToEditIngredient(ingredient: self.modifyStockViewModel.ingredient)
                        presentationMode.wrappedValue.dismiss()

                    }else{
                        intentStock.intentToDecreaseStock(quantityToBeRemoved: modifyStockViewModel.quantityToRemove)
                        intentStock.intentToEditIngredient(ingredient: self.modifyStockViewModel.ingredient)
                        presentationMode.wrappedValue.dismiss()

                    }
                }, label: {
                    Text("Modifier")
                        .font(.title2)
                        .foregroundColor(.white).padding(12)
                }).frame(maxWidth: .infinity).background(.blue).cornerRadius(10)
                
                Button(action: {
                    //dismissed the current view
                    presentationMode.wrappedValue.dismiss()
                }, label: {
                    Text("Annuler")
                        .font(.title2)
                        .foregroundColor(.white).padding(12)
                }).frame(maxWidth: .infinity).background(.red).cornerRadius(10)
            }
            
            
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .background(Color.sheetBackground)
    }
}

//struct ModifyStockView_Previews: PreviewProvider {
//    static var previews: some View {
//        ModifyStockView()
//    }
//}
