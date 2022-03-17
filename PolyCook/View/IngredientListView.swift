import SwiftUI

struct IngredientListView: View {
    @ObservedObject var ingredientListViewModel = IngredientListViewModel()
    var intentIngredient: IntentIngredient
    
    init(){
        self.intentIngredient = IntentIngredient()
        self.intentIngredient.addObserver(viewModel: ingredientListViewModel)
    }
    
    var body: some View {
        NavigationView{
            ZStack {
                VStack {
                    List {
                        Section {
                            HStack(spacing: 15) {
                                Button (action: {
                                    withAnimation{ingredientListViewModel.showCategoryFilter.toggle()}
                                }, label: {
                                    Text("Catégorie").font(.system(size: 21))
                                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                                })
                                    .background(.blue)
                                    .foregroundColor(.white)
                                    .cornerRadius(10)
                                    .buttonStyle(BorderlessButtonStyle())
                                
                                Button (action: {
                                    withAnimation{ingredientListViewModel.showAllergenFilter.toggle()}
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
                            if ingredientListViewModel.filterResults.count == 0 {
                                Text("Aucun ingrédient")
                                    .font(.system(size: 21))
                                    .bold()
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 20)
                                    .listRowBackground(Color.white.opacity(0))
                                    .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                            }
                            ForEach(ingredientListViewModel.filterResults, id: \.id) {ingredient in
                                Button {
                                    ingredientListViewModel.showingInfoSheet.toggle()
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
                                    }.frame(height: 50)
                                }
                                .sheet(isPresented : $ingredientListViewModel.showingInfoSheet) {
                                    IngredientView(ingredientViewModel: IngredientViewModel(ingredient: ingredient), ingredientListViewModel: self.ingredientListViewModel)
                                }
                            }
                            .onDelete {
                                ingredientListViewModel.remove(atOffsets: $0)
                            }
                        }
                    }
                    .searchable(text: $ingredientListViewModel.enteredText, placement: .navigationBarDrawer(displayMode: .always), prompt: "Recherche ingrédient")
                    .navigationTitle("Ingrédients")
                    .toolbar {
                        ToolbarItem(placement: .navigationBarTrailing) {
                            Button{
                                ingredientListViewModel.showingCreationSheet.toggle()
                            } label: {
                                Image(systemName: "cart.badge.plus")
                            }
                        }
                    }
                    .sheet(isPresented : $ingredientListViewModel.showingCreationSheet) {
                        CreateIngredientView(ingredientListViewModel: self.ingredientListViewModel,ingredient:Ingredient(id: UUID().uuidString, nomIng: "",nomCat:"Crustacés", nomCatAllerg: nil, unite: "Kg"))
                    }
                }
                FilterMenu(title: "Catégorie", height: 250, isOn: $ingredientListViewModel.showCategoryFilter, filter: ingredientListViewModel.categoryFilters)
                FilterMenu(title: "Type Allergène", height: 250, isOn: $ingredientListViewModel.showAllergenFilter, filter: ingredientListViewModel.allergenFilters) 
            }
        }
        .navigationViewStyle(StackNavigationViewStyle()) //to fix constraints error that appear in the console due to navigationTitle
    }
}

//struct IngredientListView_Previews: PreviewProvider {
//    static var previews: some View {
////        IngredientListView()
//    }
//}
