import SwiftUI

struct CoefficientsView: View {
    //to make the back button dismiss the current view
    @Environment(\.presentationMode) var presentationMode
    
    @ObservedObject var viewM = CoefficientsViewModel()
    
    var body: some View {
        ScrollView {
            VStack{
                Text("Coefficients").font(.system(size: 40)).bold()
                
                Spacer().frame(height: 10)
                
                VStack (spacing: 0){
                    VStack (spacing: 18){
                        Text("Coûts horaires").font(.system(size: 25)).bold()
                        VStack (spacing: 5) {
                            Text("Coût horaire moyen (€)").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                            TextField("Coût horaire moyen", value: $viewM.coutHoraireMoyen, formatter: viewM.numberFormatter)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.pageElementBackground))
                                .foregroundColor(Color.textFieldForeground)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        
                        VStack (spacing: 5) {
                            Text("Coût horaire forfaitaire (€)").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                            TextField("Coût horaire forfaitaire", value: $viewM.coutHoraireForfaitaire, formatter: viewM.numberFormatter)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.pageElementBackground))
                                .foregroundColor(Color.textFieldForeground)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .keyboardType(.numbersAndPunctuation)
                        }
                    }
                    
                    Divider().padding([.top, .bottom], 30)
                    
                    VStack (spacing: 18){
                        Text("Coefficients multiplicateurs").font(.system(size: 25)).bold()
                        VStack (spacing: 5) {
                            Text("Sans évalution").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                            TextField("Sans évalution", value: $viewM.coeffMultiSans, formatter: viewM.numberFormatter)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.pageElementBackground))
                                .foregroundColor(Color.textFieldForeground)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .keyboardType(.numbersAndPunctuation)
                        }
                        
                        VStack (spacing: 5) {
                            Text("Avec évalution").frame(maxWidth: .infinity, alignment: .leading).padding(.leading, 10).font(.title2)
                            TextField("Avec évalution", value: $viewM.coeffMultiAvec, formatter: viewM.numberFormatter)
                                .padding(10)
                                .background(RoundedRectangle(cornerRadius: 10)
                                                .fill(Color.pageElementBackground))
                                .foregroundColor(Color.textFieldForeground)
                                .disableAutocorrection(true)
                                .autocapitalization(.none)
                                .keyboardType(.numbersAndPunctuation)
                        }
                    }
                }
                .padding(.top, 10)
                
                Spacer().frame(height: 30)
                
                HStack (spacing: 20) {
                    Button(action: {
                        //update the data in the DB
                        viewM.updateCoefficients()
                        //then dismiss the view
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Sauvegarder")
                            .font(.title2).foregroundColor(.white).padding(12)
                            .frame(maxWidth: .infinity)
                    }).background(.blue).cornerRadius(10)
                    
                    Button(action: {
                        //reset the field to the original value
                        viewM.resetValues()
                        //then dismiss the view
                        presentationMode.wrappedValue.dismiss()
                    }, label: {
                        Text("Annuler")
                            .font(.title2).foregroundColor(.white).padding(12)
                            .frame(maxWidth: .infinity)
                    }).background(.red).cornerRadius(10)
                }
                Spacer()
            }
            .padding(.top, 20)
            .padding([.leading, .trailing], 20)
            .background(Color.pageBackground)
            .navigationBarTitle("")
            .navigationBarHidden(true)
        }
        .background(Color.pageBackground)
    }
}

struct CoefficientsView_Previews: PreviewProvider {
    static var previews: some View {
        CoefficientsView()
    }
}
