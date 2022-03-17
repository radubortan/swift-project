import SwiftUI

struct IngredientView: View {
    @ObservedObject var ingredientViewModel : IngredientViewModel
    @ObservedObject var ingredientListViewModel : IngredientListViewModel
    var intentIngredient: IntentIngredient
    
    init(ingredientViewModel: IngredientViewModel, ingredientListViewModel: IngredientListViewModel){
        self.ingredientViewModel = ingredientViewModel
        self.ingredientListViewModel = ingredientListViewModel
        self.intentIngredient = IntentIngredient()
        self.intentIngredient.addObserver(viewModel: ingredientViewModel)
        self.intentIngredient.addObserver(viewModel: ingredientListViewModel)
    }
    
    var body: some View {
        VStack (spacing: 20){
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(10)
            
            Text(self.ingredientViewModel.nomIng).font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            HStack (spacing: 20){
                VStack (spacing: 10){
                    Text("Prix unitaire")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text(String(format: "%.2f€", self.ingredientViewModel.prixUnitaire))
                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
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
                    Text(self.ingredientViewModel.unite)
                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
            }
            
            VStack (spacing: 10) {
                Text("Catégorie")
                    .font(.title2).frame(maxWidth: .infinity, alignment: .center)
                Divider()
                Text(ingredientViewModel.nomCat)
                    .font(.system(size: ingredientViewModel.smallText))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.sheetElementBackground)
            .cornerRadius(10)
            
            
            if let currentAllergCategory = ingredientViewModel.nomCatAllerg {
                VStack (spacing: 10) {
                    Text("Catégorie d'allergène")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .center)
                    Divider()
                    Text(currentAllergCategory)
                        .font(.system(size: ingredientViewModel.smallText))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
            }
            Button(action: {
                ingredientViewModel.showingSheet.toggle()
            }, label: {
                Text("Modifier ingrédient")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
                    .frame(maxWidth: .infinity)
            }).background(.blue).cornerRadius(10)
                .sheet(isPresented : $ingredientViewModel.showingSheet) {
                    EditIngredientView(ingredientViewModel: ingredientViewModel, ingredientListViewModel: ingredientListViewModel)                            }
            
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .background(Color.sheetBackground)
        
    }
}
//struct IngredientView_Previews: PreviewProvider {
//    static var previews: some View {
//        IngredientView()
//            .preferredColorScheme(.dark)
//    }
//}
