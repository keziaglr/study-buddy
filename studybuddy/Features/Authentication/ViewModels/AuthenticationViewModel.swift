//
//  AuthenticationViewModel.swift
//  studybuddy
//
//  Created by Kezia Gloria on 23/06/23.
//

import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

@MainActor
final class AuthenticationViewModel : ObservableObject {
    
    @Published var authenticated = false
    @Published var created = false
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    
    func auth() async throws {
        try await AuthenticationManager.shared.signInUser(email: email, password: password)
        authenticated = true
    }
    
    func createUser() async throws {
        let user = try await AuthenticationManager.shared.createUser(email: email, password: password)
        created = true
        addUserToFirestore(userUID: user.uid)
    }
    
    func addUserToFirestore(userUID: String) {
        let user = UserModel(id: userUID, name: name, email: email, password: password, image: "", category: ["placeholder"], badges: [], communities: [])
        UserManager.shared.addUser(user: user)
    }
    
    func checkLogin() -> Bool{
        return email.isEmpty || password.count < 6
    }
    
    func checkRegister() -> Bool{
        return name.isEmpty || email.isEmpty || password.count < 6
    }
    
    func logout() throws {
        try AuthenticationManager.shared.signOut()
        authenticated = false
    }
    
}
