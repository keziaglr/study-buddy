//
//  AuthenticationManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import Foundation
import FirebaseAuth

final class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {}
    
    func getAuthenticatedUser() throws -> User {
        guard let user = Auth.auth().currentUser else {
            throw URLError(.badServerResponse)
        }
        return user
    }
    
    @discardableResult
    func createUser(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().createUser(withEmail: email, password: password)
//        let result = UserModel(user: authDataResult.user)
        return authDataResult.user
    }
    
    @discardableResult
    func signInUser(email: String, password: String) async throws -> User {
        let authDataResult = try await Auth.auth().signIn(withEmail: email, password: password)
        return authDataResult.user
    }
    
    func signOut() throws {
        print("logged out")
        let firebaseAuth = Auth.auth()
        do {
          try firebaseAuth.signOut()
        } catch let signOutError as NSError {
          print("Error signing out: %@", signOutError)
        }
    }
    
    func resetPassword(email: String) async throws {
        try await Auth.auth().sendPasswordReset(withEmail: email)
    }
}
