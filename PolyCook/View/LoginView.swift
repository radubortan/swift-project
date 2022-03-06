import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginVM : LoginViewModel
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("Connexion").font(.system(size: 40)).bold()
            
            TextField("Email", text: $loginVM.email)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.pageElementBackground))
                .foregroundColor(Color.textFieldForeground)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Mot de passe", text: $loginVM.password)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.pageElementBackground))
                .foregroundColor(Color.textFieldForeground)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            Spacer().frame(height: 20)
            
            Button(action: {
                guard !loginVM.email.isEmpty, !loginVM.password.isEmpty else {
                    return
                }
                loginVM.signIn(email: loginVM.email, password: loginVM.password)
            }, label: {
                Text("Se connecter")
                    .font(.system(size: 20))
                    .foregroundColor(.white)
                    .padding(12)
                    .background(.blue)
            })
                .cornerRadius(10)
            Spacer()
        }
        .padding(20)
        .background(Color.pageBackground)
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
