import SwiftUI

struct StockView: View {
    let bigText = CGFloat(25)
    let smallText = CGFloat(20)
    
    @State private var showingSheet = false
    
    var body: some View {
        VStack (spacing: 20){
            Capsule()
                .fill(Color.secondary)
                .frame(width: 35, height: 5)
                .padding(10)
            
            Text("Crevette").font(.system(size: 40)).bold().multilineTextAlignment(.center)
            
            HStack (spacing: 20){
                VStack (spacing: 10){
                    Text("Prix unitaire")
                        .font(.title2).frame(maxWidth: .infinity, alignment: .leading)
                    Divider()
                    Text("2.00€")
                        .font(.system(size: smallText)).frame(maxWidth: .infinity, alignment: .leading)
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
                        .font(.system(size: smallText)).frame(maxWidth: .infinity, alignment: .leading)
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
                    Text("Crustacés")
                        .font(.system(size: smallText)).frame(maxWidth: .infinity, alignment: .leading)
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
                    Text("2")
                        .font(.system(size: smallText)).frame(maxWidth: .infinity, alignment: .leading)
                }
                .padding(15)
                .frame(maxWidth: .infinity)
                .frame(height: 100)
                .background(Color.sheetElementBackground)
                .cornerRadius(10)
            }
            
            VStack (spacing: 10) {
                Text("Catégorie d'allergène")
                    .font(.title2).frame(maxWidth: .infinity, alignment: .center)
                Divider()
                Text("Crustacés")
                    .font(.system(size: smallText)).frame(maxWidth: .infinity, alignment: .center)
            }
            .padding(15)
            .frame(maxWidth: .infinity)
            .frame(height: 100)
            .background(Color.sheetElementBackground)
            .cornerRadius(10)
            
            Button(action: {
                showingSheet.toggle()
            }, label: {
                Text("Modifier Stock")
                    .font(.title2)
                    .foregroundColor(.white)
                    .padding(12)
            }).frame(maxWidth: .infinity).background(.blue).cornerRadius(10)
                .sheet(isPresented : $showingSheet) {
                    ModifyStockView()
                }
            
            Spacer()
        }
        .padding([.leading, .trailing], 20)
        .background(Color.sheetBackground)
    }
}

struct StockView_Previews: PreviewProvider {
    static var previews: some View {
        StockView()
            .preferredColorScheme(.dark)
    }
}
