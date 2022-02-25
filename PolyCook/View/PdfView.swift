import SwiftUI

struct PdfView: View {
    @ObservedObject var pdfVm : PdfViewModel = PdfViewModel()
    
    
    var body: some View {
        ScrollView {
            Button {
                exportPDF {
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
            .padding(10)
            
            VStack (spacing: 20) {
                Text("Pates carbonara").font(.title)
                HStack (spacing: 20){
                    VStack {
                        Text("Auteur")
                        Text("Radu Bortan")
                    }
                    VStack {
                        Text("Type de plat")
                        Text("Principal")
                    }
                    VStack {
                        Text("N° Couverts")
                        Text("2")
                    }
                }
                
                Divider()
                
                VStack {
                    Text("Cuire les pates").font(.title2)
                    Text("Durée: 10 min")
                    HStack (alignment: .top, spacing: 10){
                        VStack {
                            Text("Ingrédients").font(.title3)
                            Text("Pates")
                            Text("Sel")
                        }
                        .frame(maxWidth: .infinity)
                        
                        Divider()
                        
                        VStack {
                            Text("Description").font(.title3)
                            Text("Chauffer l'eau à ébullition puis mettre les pâtes dans l'eau pendant 15 minutes.")
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.top, 10)
                }
                
            }
        }
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

struct PdfView_Previews: PreviewProvider {
    static var previews: some View {
        PdfView()
    }
}

