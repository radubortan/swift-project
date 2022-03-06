import SwiftUI

struct RecipeIngredientListView: View {
    @ObservedObject var vm : RecipeIngredientListViewModel
    
    init(steps : [Step]) {
        self.vm = RecipeIngredientListViewModel(steps: steps)
    }
    
    var body: some View {
        VStack (spacing :20) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(.top, 10)
                .background(Color.sheetBackground)
            
            List {
                Section {
                    Text("Ingrédients").font(.system(size: 40)).bold().frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.white.opacity(0))
                
                Section (header: Text("Normaux").font(.title2).textCase(.none).padding(.top, 5)) {
                    if vm.hasNormalIngredients {
                        ForEach(vm.ingredients, id: \.id) {ingredient in
                            if ingredient.ingredient.nomCatAllerg == nil {
                                HStack {
                                    Text(ingredient.ingredient.nomIng)
                                    Spacer()
                                    Text("\(String(format: "%.1f", ingredient.quantity)) \(ingredient.ingredient.unite)")
                                        .frame(width: 75, height: 30)
                                        .background(Color.innerTextFieldBackground)
                                        .cornerRadius(10)
                                        .foregroundColor(Color.textFieldForeground)
                                }
                                .background(Color.sheetElementBackground)
                            }
                        }
                    }
                    else {
                        Text("Aucun ingrédient")
                            .font(.system(size: 21))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.white.opacity(0))
                    }
                }
                
                Section (header: Text("Allergènes").font(.title2).textCase(.none).padding(.top, 5)) {
                    if vm.hasAllergens {
                        ForEach(vm.ingredients, id: \.id) {ingredient in
                            if ingredient.ingredient.nomCatAllerg != nil {
                                HStack {
                                    Text(ingredient.ingredient.nomIng)
                                    Spacer()
                                    Text("\(String(format: "%.1f", ingredient.quantity)) \(ingredient.ingredient.unite)")
                                        .frame(width: 75, height: 30)
                                        .background(Color.innerTextFieldBackground)
                                        .cornerRadius(10)
                                        .foregroundColor(Color.textFieldForeground)
                                }
                                .background(Color.sheetElementBackground)
                            }
                        }
                    }
                    else {
                        Text("Aucun ingrédient")
                            .font(.system(size: 21))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            .listRowBackground(Color.white.opacity(0))
                    }
                }
            }
        }
        .background(Color.sheetBackground)
    }
}

//struct RecipeIngredientListView_Previews: PreviewProvider {
//    static var previews: some View {
//        RecipeIngredientListView()
//    }
//}
