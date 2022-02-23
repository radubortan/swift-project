import SwiftUI

struct CardView: View {
    @State var filter: FilterItem
    
    var body: some View {
        HStack {
            Text(filter.title)
                .bold()
                .foregroundColor(.textFieldForeground.opacity(0.7))
            
            Spacer()
            
            ZStack {
                Circle()
                    .strokeBorder(filter.checked ? Color.blue : Color.gray, lineWidth: filter.checked ? 2 : 1)
                    .frame(width: 25, height: 25)
                
                if filter.checked {
                    Image(systemName: "checkmark.circle.fill")
                        .font(.system(size: 22))
                        .foregroundColor(.blue)
                }
            }
        }
        .padding(.vertical, 2)
        .padding(.horizontal)
        .contentShape(Rectangle()) //to be able to press anywhere on the line to select
        .onTapGesture {
            filter.checked.toggle()
        }
    }
}

struct CardView_Previews: PreviewProvider {
    static var previews: some View {
        CardView(filter: FilterItem(checked: true, title: ""))
    }
}
