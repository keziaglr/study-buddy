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


final class AuthenticationViewModel : ObservableObject {
    
    let db = Firestore.firestore()
    @Published var authenticated = false
    @Published var created = false
    @Published var name = ""
    @Published var email = ""
    @Published var password = ""
    @Published var authenticatedUser: UserModel?
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
        let user = UserModel(id: userUID, name: name, email: email, password: password, image: "", category: ["placeholder"], badges: [])
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
    
    func getCurrentUser() async throws -> UserModel? {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return nil
        }
        authenticatedUser = try await UserManager.shared.getCurrentUser(userID: currentUserID)
        return authenticatedUser
    }
    
    func resetPassword() {
        Auth.auth().sendPasswordReset(withEmail: email) { error in
            if let error = error {
                print("Error: \(error.localizedDescription)")
                return
            }
            
            print("reset password")
        }
    }
}
