import SwiftUI
import Firebase

@main
struct PolyCookApp: App {
    
    init() {
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            let loginVM = LoginViewModel()
            StartingView()
                .environmentObject(loginVM)
        }
    }
}
