//
//  studybuddyApp.swift
//  studybuddy
//
//  Created by Kezia Gloria on 20/06/23.
//

import SwiftUI
import Firebase

@main
struct studybuddyApp: App {
    init(){
        FirebaseApp.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            OnboardingPageView()
        }
    }
}
