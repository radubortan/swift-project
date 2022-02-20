//
//  LoginView.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var loginVM : LoginViewModel
    
    @State var email : String = ""
    @State var password : String = ""
    
    var body: some View {
        VStack{
            Spacer()
            
            Text("Connexion").font(.system(size: 40)).bold()
            
            TextField("Email", text: $email)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.textFieldBackground))
                .foregroundColor(Color.textFieldForeground)
                .disableAutocorrection(true)
                .autocapitalization(.none)
                .keyboardType(.emailAddress)
            
            SecureField("Mot de passe", text: $password)
                .padding(10)
                .background(RoundedRectangle(cornerRadius: 10)
                                .fill(Color.textFieldBackground))
                .foregroundColor(Color.textFieldForeground)
                .disableAutocorrection(true)
                .autocapitalization(.none)
            
            Spacer().frame(height: 20)
            
            Button(action: {
                guard !email.isEmpty, !password.isEmpty else {
                    return
                }
                loginVM.signIn(email: email, password: password)
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
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
            .preferredColorScheme(.dark)
    }
}
