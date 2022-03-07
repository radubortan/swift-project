//
//  TicketView.swift
//  PolyCook
//
//  Created by Radu Bortan on 07/03/2022.
//

import SwiftUI

struct TicketView: View {
    @ObservedObject var ticketVm : TicketViewModel
    
    let infoColumns = [GridItem](repeating: .init(.flexible()), count: 2)
    
    init(recipe: Recette) {
        self.ticketVm = TicketViewModel(recipe : recipe)
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
                    exportPDF(fileName: "Ticket - \(ticketVm.recipe.nomRecette)") {
                        self
                    } completion: { status, url in
                        if let url = url, status {
                            self.ticketVm.PDFUrl = url
                            self.ticketVm.showShareSheet.toggle()
                        }
                        else {
                            print("Failed to create ticket")
                        }
                    }
                } label : {
                    Image(systemName: "square.and.arrow.up")
                }
                .frame(maxWidth: .infinity, alignment: .trailing)
                .padding(.trailing, 10)
                
                VStack (spacing: 10) {
                    Text(ticketVm.recipe.nomRecette).font(.system(size: 30)).bold().padding(.bottom, 10)
                    
                    HStack (spacing: 20){
                        VStack {
                            Text("Normaux").font(.title2).padding(.bottom, 5)
                            Divider().padding(.horizontal, 30)
                            ForEach(ticketVm.ingredients, id: \.id) { ingredient in
                                if ingredient.ingredient.nomCatAllerg == nil {
                                    Text("- \(ingredient.ingredient.nomIng)")
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                        
                        VStack {
                            Text("Allergènes").font(.title2).padding(.bottom, 5)
                            Divider().padding(.horizontal, 30)
                            ForEach(ticketVm.ingredients, id: \.id) { ingredient in
                                if ingredient.ingredient.nomCatAllerg != nil {
                                    Text("- \(ingredient.ingredient.nomIng)").bold()
                                }
                            }
                        }
                        .frame(maxWidth: .infinity)
                    }
                    .padding(.horizontal, 5)
                }
            }
        }
        .padding(.bottom, 30)
        .background(.white)
        .foregroundColor(.black)
        .sheet(isPresented: $ticketVm.showShareSheet) {
            ticketVm.PDFUrl = nil
        } content: {
            if let PDFUrl = ticketVm.PDFUrl {
                ShareSheet(urls: [PDFUrl])
            }
        }
    }
}

//struct TicketView_Previews: PreviewProvider {
//    static var previews: some View {
//        TicketView()
//    }
//}
