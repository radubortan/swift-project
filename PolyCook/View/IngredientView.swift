import SwiftUI

struct IngredientView: View {
    let bigText = CGFloat(25)
    let smallText = CGFloat(20)
    
    @State private var showingSheet = false
    
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
            Text(self.ingredientViewModel.nomIng).font(.system(size: 40)).bold().multilineTextAlignment(.center)
            HStack (spacing: 20){
                VStack (spacing: 10){
                    Text("Prix unitaire")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("2.00€")
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
                    Text("Kg")
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
                    .font(.system(size: smallText))
            }
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.textFieldBackground)
            .cornerRadius(10)
            
            
            if let currentAllergCategory = ingredientViewModel.nomCatAllerg {
                VStack (spacing: 10) {
                    Text("Catégorie d'allergène")
                        .font(.system(size: bigText))
                    Divider()
                    Text(currentAllergCategory)
                        .font(.system(size: smallText))
                }
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.textFieldBackground)
                .cornerRadius(10)
            }
            

            Spacer()
        }.padding(20)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button{
                    showingSheet.toggle()
                } label: {
                    Text("Modifier")
                }
                .sheet(isPresented : $showingSheet) {
                    EditIngredientView(ingredientViewModel: ingredientViewModel, ingredientListViewModel: ingredientListViewModel)
                }
            
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
