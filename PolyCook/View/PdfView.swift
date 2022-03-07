import SwiftUI

struct PdfView: View {
    @ObservedObject var pdfVm : PdfViewModel
    
    //grid elements
    let infoColumns = [GridItem](repeating: .init(.flexible()), count: 3)
    let ingredientsColumns = [GridItem(.flexible(), spacing: 0), GridItem(.fixed(40), spacing: 0), GridItem(.fixed(40), spacing: 0)]
    let costsColumns = [GridItem](repeating: .init(.flexible(), spacing: 0), count: 4)
    
    
    init(costsInfo: CostsInfo, showCosts : Binding<Bool>, quantity: Binding<Int>, recipe : Recette) {
        self.pdfVm = PdfViewModel(costsInfo: costsInfo, showCosts: showCosts, quantity: quantity, recipe : recipe)
    }
    
    var body: some View {
        VStack {
            Capsule()
                .fill(Color(red: 133/255, green: 133/255, blue: 138/255))
                .frame(width: 35, height: 5)
                .padding(.top, 10)
                .padding(.bottom, 10)
                .background(.white.opacity(0))
            
            ScrollView {
                Button {
                    exportPDF(recipeName: pdfVm.recipe.nomRecette) {
                        self
                    } completion: { status, url in
                        if let url = url, status {
                            self.pdfVm.PDFUrl = url
                            self.pdfVm.showShareSheet.toggle()
                        }
                        else {
                            print("Failed to create PDF")
                        }
                    }
                } label : {
                    Image(systemName: "square.and.arrow.up")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
                
                VStack (spacing: 10) {
                    Text(pdfVm.recipe.nomRecette).font(.system(size: 30)).bold().padding(.bottom, 10)
                    
                    LazyVGrid (columns: infoColumns) {
                        VStack (spacing: 3){
                            Text("Auteur").font(.system(size: 9)).bold()
                            Divider()
                            Text(pdfVm.recipe.nomAuteur).font(.system(size: 9))
                        }
                        
                        VStack (spacing: 3){
                            Text("Type de plat").font(.system(size: 9)).bold()
                            Divider()
                            Text(pdfVm.recipe.nomCatRecette).font(.system(size: 9))
                        }
                        
                        VStack (spacing: 3){
                            Text("N° Couverts").font(.system(size: 9)).bold()
                            Divider()
                            Text("\(pdfVm.quantity.wrappedValue)").font(.system(size: 9))
                        }
                    }
                    .padding(.horizontal, 70)
                    
                    Divider()
                    
                    
                    ForEach(pdfVm.steps, id: \.id) { step in
                        VStack (spacing: 2){
                            Text(step.nomEtape!).font(.title3).bold()
                            Text("Durée: \(step.duree) min").font(.system(size: 12))
                            HStack (alignment: .top, spacing: 0){
                                VStack (spacing: 3){
                                    Text("Ingrédients").font(.system(size: 14)).bold()
                                    Divider()
                                    LazyVGrid (columns: ingredientsColumns, spacing: 2) {
                                        Text("Ingrédient").font(.system(size: 9)).bold()
                                        Text("Quantité").font(.system(size: 9)).bold()
                                        Text("Unité").font(.system(size: 9)).bold()
                                        ForEach(step.ingredients, id: \.id){ ingredient in
                                            Group {
                                                Divider()
                                                Divider()
                                                Divider()
                                                Text(ingredient.ingredient.nomIng).font(.system(size: 9))
                                                Text("\(String(format: "%.1f", ingredient.quantity))").font(.system(size: 9))
                                                Text(ingredient.ingredient.unite).font(.system(size: 9))
                                            }
                                        }   
                                    }
                                }
                                .frame(maxWidth: .infinity)
                                
                                Divider()
                                
                                VStack (spacing: 3) {
                                    Text("Description").font(.system(size: 14)).bold()
                                    Divider()
                                    Text(step.description)
                                        .font(.system(size: 9))
                                        .padding(2)
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .padding(.top, 10)
                        }
                    }
                    Divider()
                    if pdfVm.showCosts.wrappedValue {
                        VStack {
                            Text("Coûts").font(.title3).bold()
                            LazyVGrid(columns : costsColumns, spacing: 10) {
                                VStack (spacing: 3) {
                                    Text("Coût matière").font(.system(size: 9)).bold()
                                    Divider().padding(.horizontal, 2)
                                    Text(String(format: "%.2f€", self.pdfVm.coutMatiere)).font(.system(size: 9))
                                }
                                
                                if pdfVm.costsInfo.withCharges {
                                    VStack (spacing: 3) {
                                        Text("Coût des charges").font(.system(size: 9)).bold()
                                        Divider().padding(.horizontal, 2)
                                        Text(String(format: "%.2f€", self.pdfVm.coutCharges)).font(.system(size: 9))
                                    }
                            
                                    VStack (spacing: 3) {
                                        Text("Coût du personnel").font(.system(size: 9)).bold()
                                        Divider().padding(.horizontal, 2)
                                        Text(String(format: "%.2f€", self.pdfVm.coutPersonnel)).font(.system(size: 9))
                                    }
                                    
                                    VStack (spacing: 3) {
                                        Text("Coût des fluides").font(.system(size: 9)).bold()
                                        Divider().padding(.horizontal, 2)
                                        Text(String(format: "%.2f€", self.pdfVm.coutFluide)).font(.system(size: 9))
                                    }
                                }
                                
                                VStack (spacing: 3) {
                                    Text("Coût de production").font(.system(size: 9)).bold()
                                    Divider().padding(.horizontal, 2)
                                    Text(String(format: "%.2f€", self.pdfVm.coutProduction)).font(.system(size: 9))
                                }
                                
                                VStack (spacing: 3) {
                                    Text("Prix de vente total").font(.system(size: 9)).bold()
                                    Divider().padding(.horizontal, 2)
                                    Text(String(format: "%.2f€", self.pdfVm.coutVente)).font(.system(size: 9))
                                }
                                
                                VStack (spacing: 3) {
                                    Text("Bénéfice par portion").font(.system(size: 9)).bold()
                                    Divider().padding(.horizontal, 2)
                                    Text(String(format: "%.2f€", self.pdfVm.coutVenteParPortion)).font(.system(size: 9))
                                }
                            }
                        }
                        .padding(.horizontal, 5)
                    }
                    
                }
            }
        }
        .padding(.bottom, 30)
        .background(.white)
        .foregroundColor(.black)
        .sheet(isPresented: $pdfVm.showShareSheet) {
            pdfVm.PDFUrl = nil
        } content: {
            if let PDFUrl = pdfVm.PDFUrl {
                ShareSheet(urls: [PDFUrl])
            }
        }
    }
}

//struct PdfView_Previews: PreviewProvider {
//    static var previews: some View {
//        PdfView(withCosts: false)
//    }
//}

