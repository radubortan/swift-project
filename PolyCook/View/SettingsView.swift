import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var loginVM : LoginViewModel
    
    @State var confirmationShown : Bool = false
    
    var body: some View {
        NavigationView{
            VStack {
                List {
                    Section() {
                        NavigationLink(destination: CoefficientsView()){
                            Text("Coefficients")
                                .font(.system(size: 21))
                        }
                    }
                    
                    Section() {
                        Button{
                            confirmationShown = true
                        } label: {
                            HStack {
                                Image(systemName: "rectangle.portrait.and.arrow.right")
                                    .foregroundColor(.red)
                                Text("Déconnexion")
                                    .foregroundColor(.red)
                                    .font(.system(size: 21))
                            }
                        }
                        .confirmationDialog(
                            "Voulez vous vous déconnecter?",
                            isPresented : $confirmationShown,
                            titleVisibility: .visible
                        ) {
                            Button("Oui") {
                                withAnimation {
                                    loginVM.signOut()
                                }
                            }
                            Button("Non", role: .cancel) {}
                        }
                    }
                }
                Spacer()
            }
            .navigationTitle("Paramètres")
        }
        .navigationViewStyle(StackNavigationViewStyle()) //to fix constraints error that appear in the console due to navigationTitle
    }
}

struct SettingsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsView()
    }
}
