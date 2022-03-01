import SwiftUI

struct FilterMenu: View {
    let title : String
    let height : CGFloat
    
    var isOn : Binding<Bool>
    var filters : Binding<[FilterItem]>
    
    var body: some View {
        VStack {
            Spacer()
            VStack (spacing: 10) {
                HStack {
                    Text(title)
                        .font(.title2)
                        .bold()
                        .foregroundColor(.textFieldForeground)
                    
                    Spacer()
                    
                    Button(action : {
                        withAnimation{isOn.wrappedValue.toggle()}
                    }, label : {
                        Text("Done")
                            .bold()
                            .foregroundColor(.blue)
                    })
                }
                .padding([.horizontal, .top])
                .padding(.bottom, 10)
                
                ScrollView(.vertical) {
                    ForEach(filters.wrappedValue, id: \.self) {filter in
                        CardView(filter: filter)
                    }
                }
                .padding(.bottom, 10)
                .frame(height: height)
                
            }
            .padding(.top, 10)
            .padding(.bottom, 90)
            .background(Color.sheetBackground.clipShape(CustomCorner(corners: [.topLeft, .topRight])))
            .offset(y: isOn.wrappedValue ? 90 : UIScreen.main.bounds.height)
        }
        .background(Color.black.opacity(isOn.wrappedValue ? 0.5 : 0).onTapGesture {
            withAnimation{isOn.wrappedValue.toggle()}
        })
    }
}

//struct FilterMenu_Previews: PreviewProvider {
//    static var previews: some View {
//        FilterMenu(title: "", height: 150, isOn: true)
//    }
//}
