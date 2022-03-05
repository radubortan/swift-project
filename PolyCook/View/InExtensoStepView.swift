import SwiftUI

struct InExtensoStepView: View {
    let etape : InExtensoStep
    
    init(etape: InExtensoStep) {
        self.etape = etape
    }
    
    var body: some View {
        VStack (spacing: 20) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(.top, 10)
                .background(Color.sheetBackground)
            
            List {
                //step titlet
                Section {
                    Text(etape.nomEtape!)
                        .font(.title)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .center)
                        .multilineTextAlignment(.center)
                }
                .listRowBackground(Color.white.opacity(0))
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //duration
                Section {
                    VStack (spacing: 10) {
                        Text("Durée")
                            .font(.title2).frame(maxWidth: .infinity, alignment: .center)
                        Divider()
                        Text("\(etape.duree) min")
                            .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .center)
                    }
                    .padding(15)
                    .frame(height: 100, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .background(Color.sheetElementBackground)
                    .cornerRadius(10)
                }
                
                //description
                Section {
                    VStack (spacing: 5) {
                        Text("Description").font(.title2).frame(maxWidth: .infinity, alignment: .center).padding(.leading, 10)
                        Divider()
                            .padding(.horizontal, 15)
                            .padding(.vertical, 5)
                        Text(etape.description)
                            .foregroundColor(Color.textFieldForeground)
                            .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.leading, 10)
                            .multilineTextAlignment(.leading)
                        Spacer()
                    }
                    .padding(.vertical, 15)
                    .frame(alignment: .center)
                    .frame(maxWidth: .infinity)
                    .background(Color.sheetElementBackground)
                    .cornerRadius(10)
                }
                
                //ingredients
                Section {
                    Text("Ingrédients")
                        .font(.system(size: 30))
                        .bold()
                        .frame(maxWidth: .infinity)
                        .padding(.top, 40)
                        .padding(.bottom, 10)
                        .textCase(.none)
                        .foregroundColor(Color.textFieldForeground)
                }
                .listRowBackground(Color.white.opacity(0))
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                
                Section (header: Text("Normaux").font(.title2).textCase(.none)) {
                    ZStack {
                        Text("Aucun ingrédient")
                            .font(.system(size: 21))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        ForEach(etape.ingredients, id: \.id) {ingredient in
                            if ingredient.ingredient.nomCatAllerg == nil {
                                HStack {
                                    Text(ingredient.ingredient.nomIng)
                                    Spacer()
                                    Text("\(ingredient.quantity) \(ingredient.ingredient.unite)")
                                        .frame(width: 50, height: 30)
                                        .background(Color.innerTextFieldBackground)
                                        .cornerRadius(10)
                                        .foregroundColor(Color.textFieldForeground)
                                }
                                .background(Color.sheetElementBackground)
                            }
                        }
                        
                    }
                }
                
                Section (header: Text("Allergènes").font(.title2).textCase(.none).padding(.top, 5)) {
                    ZStack {
                        Text("Aucun ingrédient")
                            .font(.system(size: 21))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        ForEach(etape.ingredients, id: \.id) {ingredient in
                            if ingredient.ingredient.nomCatAllerg != nil {
                                HStack {
                                    Text(ingredient.ingredient.nomIng)
                                    Spacer()
                                    Text("\(ingredient.quantity) \(ingredient.ingredient.unite)")
                                        .frame(width: 50, height: 30)
                                        .background(Color.innerTextFieldBackground)
                                        .cornerRadius(10)
                                        .foregroundColor(Color.textFieldForeground)
                                }
                                .background(Color.sheetElementBackground)
                            }
                        }
                    }
                }
            }
        }
        .background(Color.sheetBackground)
    }
}

//struct InExtensoStepView_Previews: PreviewProvider {
//    static var previews: some View {
//        InExtensoStepView()
//    }
//}
