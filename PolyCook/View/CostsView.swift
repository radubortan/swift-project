import SwiftUI

struct CostsView: View {
    
    let numberFormatter : NumberFormatter
    
    @ObservedObject var costsInfo : CostsInfo
    
    init(costsInfo: CostsInfo){
        self.costsInfo = costsInfo
        
        numberFormatter = NumberFormatter()
        //to format into decimal numbers
        numberFormatter.numberStyle = .decimal
    }
    
    //used for dismissing the keyboard
    private enum Field: Int, CaseIterable {
        case coutHoraireMoyen, coutHoraireForfaitaire, coeffSans, coeffAvec
    }
    @FocusState private var focusedField: Field?
    
    var body: some View {
        VStack (spacing: 20) {
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(.top, 10)
            
            List {
                Section {
                    Text("Coûts").font(.system(size: 40)).bold().frame(maxWidth: .infinity)
                }
                .listRowBackground(Color.white.opacity(0))
                
                Section {
                    Toggle("Paramètres particuliers", isOn: $costsInfo.customParams.animation(.linear(duration: 0.3))).font(.title2).padding(.bottom, costsInfo.customParams ? 10 : 0)
                    if costsInfo.customParams{
                        VStack (spacing: 20)  {
                            HStack (spacing: 20){
                                VStack (spacing: 5) {
                                    Text("Coût horaire moyen (€)").frame(maxWidth: .infinity, alignment: .leading).font(.title2)
                                    TextField("Coût horaire moyen (€)", value: $costsInfo.customCoutHoraireMoyen, formatter: numberFormatter)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.innerTextFieldBackground))
                                        .foregroundColor(Color.textFieldForeground)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                        .keyboardType(.numbersAndPunctuation)
                                }
                                .padding(15)
                                .frame(height: 135, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                                
                                VStack (spacing: 5) {
                                    Text("Coût horaire forfaitaire (€)").frame(maxWidth: .infinity, alignment: .leading).font(.title2)
                                    TextField("Coût horaire forfaitaire (€)", value: $costsInfo.customCoutHoraireForfaitaire, formatter: numberFormatter)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.innerTextFieldBackground))
                                        .foregroundColor(Color.textFieldForeground)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                        .keyboardType(.numbersAndPunctuation)
                                }
                                .padding(15)
                                .frame(height: 135, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                            }
                            
                            HStack (spacing: 20){
                                VStack (spacing: 5) {
                                    Text("Coeff. sans évaluation").frame(maxWidth: .infinity, alignment: .leading).font(.title2)
                                    TextField("Coeff. sans évaluation", value: $costsInfo.customCoeffMultiSans, formatter: numberFormatter)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.innerTextFieldBackground))
                                        .foregroundColor(Color.textFieldForeground)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                        .keyboardType(.numbersAndPunctuation)
                                }
                                .padding(15)
                                .frame(height: 135, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                                
                                VStack (spacing: 5) {
                                    Text("Coeff. avec évaluation").frame(maxWidth: .infinity, alignment: .leading).font(.title2)
                                    TextField("Coeff. avec évaluation", value: $costsInfo.customCoeffMultiAvec, formatter: numberFormatter)
                                        .padding(10)
                                        .background(RoundedRectangle(cornerRadius: 10)
                                                        .fill(Color.innerTextFieldBackground))
                                        .foregroundColor(Color.textFieldForeground)
                                        .disableAutocorrection(true)
                                        .autocapitalization(.none)
                                        .keyboardType(.numbersAndPunctuation)
                                }
                                .padding(15)
                                .frame(height: 135, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                            }
                        }
                    }
                }
                .listRowBackground(Color.white.opacity(0))
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2))
                
                Section {
                    VStack (spacing: 10) {
                        Text("Assaisonnement").font(.title2)
                        HStack {
                            Spacer()
                            Text("Défaut (5%)")
                            Toggle("", isOn: $costsInfo.customAssaisonnement.animation(.linear(duration: 0.3))).labelsHidden()
                            Text("Particulier")
                            Spacer()
                        }
                        if costsInfo.customAssaisonnement {
                            HStack {
                                TextField("Assaisonnement (€)", value: $costsInfo.customAssaissonnementValue, formatter: numberFormatter)
                                    .padding(10)
                                    .background(RoundedRectangle(cornerRadius: 10)
                                                    .fill(Color.innerTextFieldBackground))
                                    .foregroundColor(Color.textFieldForeground)
                                    .disableAutocorrection(true)
                                    .autocapitalization(.none)
                                    .keyboardType(.numbersAndPunctuation)
                                Text("€")
                            }
                        }
                    }
                    .padding(15)
                    .frame(height: costsInfo.customAssaisonnement ? 140 : 100, alignment: .center)
                    .frame(maxWidth: .infinity)
                    .background(Color.sheetElementBackground)
                    .cornerRadius(10)
                }
                .listRowBackground(Color.white.opacity(0))
                .padding(.top, costsInfo.customParams ? 30 : 0)
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2))
                
                Section {
                    Toggle("Charges", isOn: $costsInfo.withCharges.animation(.linear(duration: 0.3))).font(.title2).padding(.top, costsInfo.withCharges ? 10 : 0)
                    if costsInfo.withCharges {
                        HStack (spacing: 20) {
                            VStack (spacing: 10) {
                                Text("Coût horaire moyen")
                                    .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                Divider()
                                Text("2.00€")
                                    .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(15)
                            .frame(height: 130, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color.sheetElementBackground)
                            .cornerRadius(10)
                            
                            VStack (spacing: 10) {
                                Text("Coût horaire forfaitaire")
                                    .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                Divider()
                                Text("2.00€")
                                    .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                            }
                            .padding(15)
                            .frame(height: 130, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color.sheetElementBackground)
                            .cornerRadius(10)
                        }
                    }
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.white.opacity(0))
                .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2))
                
                Section (header: Text("Résumé")
                            .font(.system(size: 30))
                            .bold()
                            .frame(maxWidth: .infinity)
                            .padding(.top, 50)
                            .padding(.bottom, 15)
                            .textCase(.none)
                            .foregroundColor(Color.textFieldForeground)) {
                    VStack (spacing: 20) {
                        if costsInfo.withCharges {
                            HStack (spacing: 20) {
                                VStack (spacing: 10) {
                                    Text("Coût       matière")
                                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                    Text("2.00€")
                                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(15)
                                .frame(height: 130, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                                
                                VStack (spacing: 10) {
                                    Text("Coût des charges")
                                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                    Text("2.00€")
                                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(15)
                                .frame(height: 130, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                            }
                            
                            HStack (spacing: 20) {
                                VStack (spacing: 10) {
                                    Text("Coût du personnel")
                                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                    Text("2.00€")
                                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(15)
                                .frame(height: 130, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                                
                                VStack (spacing: 10) {
                                    Text("Coût des fluides")
                                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                    Text("2.00€")
                                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(15)
                                .frame(height: 130, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                            }
                            
                            VStack (spacing: 10) {
                                Text("Coût de production")
                                    .font(.title2).frame(maxWidth: .infinity, alignment: .center)
                                Divider()
                                Text("2.00€")
                                    .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .center)
                            }
                            .padding(15)
                            .frame(height: 100, alignment: .center)
                            .frame(maxWidth: .infinity)
                            .background(Color.sheetElementBackground)
                            .cornerRadius(10)
                        }
                        else {
                            HStack (spacing: 20) {
                                VStack (spacing: 10) {
                                    Text("Coût    matière")
                                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                    Text("2.00€")
                                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(15)
                                .frame(height: 130, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                                
                                VStack (spacing: 10) {
                                    Text("Coût de production")
                                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                                    Divider()
                                    Text("2.00€")
                                        .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .leading)
                                }
                                .padding(15)
                                .frame(height: 130, alignment: .center)
                                .frame(maxWidth: .infinity)
                                .background(Color.sheetElementBackground)
                                .cornerRadius(10)
                            }
                        }
                        
                        
                        //fixe
                        VStack (spacing: 10) {
                            Text("Prix de vente total")
                                .font(.title2).frame(maxWidth: .infinity, alignment: .center)
                            Divider()
                            Text("2.00€")
                                .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(15)
                        .frame(height: 100, alignment: .center)
                        .frame(maxWidth: .infinity)
                        .background(Color.sheetElementBackground)
                        .cornerRadius(10)
                        
                        VStack (spacing: 10) {
                            Text("Bénéfice par portion")
                                .font(.title2).frame(maxWidth: .infinity, alignment: .center)
                            Divider()
                            Text("2.00€")
                                .font(.system(size: 20)).frame(maxWidth: .infinity, alignment: .center)
                        }
                        .padding(15)
                        .frame(height: 100, alignment: .center)
                        .frame(maxWidth: .infinity)
                        .background(Color.sheetElementBackground)
                        .cornerRadius(10)
                    }
                    
                }
                            .listRowBackground(Color.white.opacity(0))
                            .listRowSeparator(.hidden)
                            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2))
            }
            .listRowBackground(Color.white.opacity(0))
            .listRowSeparator(.hidden)
            .listRowInsets(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 2))
        }
        .background(Color.sheetBackground)
    }
}

//struct CostsView_Previews: PreviewProvider {
//    static var previews: some View {
//        CostsView()
//    }
//}
