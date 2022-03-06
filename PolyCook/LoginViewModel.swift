import Foundation
import FirebaseAuth

class LoginViewModel : ObservableObject {
    let auth = Auth.auth()
    
    @Published var signedIn = false
    
    @Published var email : String = ""
    @Published var password : String = ""
    
    var isSignedIn : Bool {
        return auth.currentUser != nil
    }
    
    func signIn(email: String, password: String) {
        auth.signIn(withEmail: email, password: password) { [weak self]
            result, error in
            guard result != nil, error == nil else {
                return
            }
            DispatchQueue.main.async {
                self?.signedIn = true
            }
        }
    }
    
    func signOut() {
        try? auth.signOut()
        self.signedIn = false
    }
}
