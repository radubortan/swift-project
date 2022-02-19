//
//  PolyCookApp.swift
//  PolyCook
//
//  Created by Radu Bortan on 17/02/2022.
//

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
