import SwiftUI

struct RecipeIngredientListView: View {
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
                    HStack {
                        Text("Ingrédient 1")
                        Spacer()
                        Text("10")
                            .frame(width: 30, height: 30)
                            .background(Color.innerTextFieldBackground)
                            .cornerRadius(10)
                            .foregroundColor(Color.textFieldForeground)
                    }
                    HStack {
                        Text("Ingrédient 2")
                        Spacer()
                        Text("10")
                            .frame(width: 30, height: 30)
                            .background(Color.innerTextFieldBackground)
                            .cornerRadius(10)
                            .foregroundColor(Color.textFieldForeground)
                    }
                    HStack {
                        Text("Ingrédient 3")
                        Spacer()
                        Text("10")
                            .frame(width: 30, height: 30)
                            .background(Color.innerTextFieldBackground)
                            .cornerRadius(10)
                            .foregroundColor(Color.textFieldForeground)
                    }
                }
                
                Section (header: Text("Allergènes").font(.title2).textCase(.none).padding(.top, 5)) {
                    HStack {
                        Text("Ingrédient 4")
                        Spacer()
                        Text("10")
                            .frame(width: 30, height: 30)
                            .background(Color.innerTextFieldBackground)
                            .cornerRadius(10)
                            .foregroundColor(Color.textFieldForeground)
                    }
                    HStack {
                        Text("Ingrédient 5")
                        Spacer()
                        Text("10")
                            .frame(width: 30, height: 30)
                            .background(Color.innerTextFieldBackground)
                            .cornerRadius(10)
                            .foregroundColor(Color.textFieldForeground)
                    }
                    HStack {
                        Text("Ingrédient 6")
                        Spacer()
                        Text("10")
                            .frame(width: 30, height: 30)
                            .background(Color.innerTextFieldBackground)
                            .cornerRadius(10)
                            .foregroundColor(Color.textFieldForeground)
                    }
                }
            }
        }.background(Color.sheetBackground)
    }
}

struct RecipeIngredientListView_Previews: PreviewProvider {
    static var previews: some View {
        RecipeIngredientListView()
    }
}
