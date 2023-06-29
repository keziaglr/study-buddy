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
    
    func auth(email: String, password: String) {
//        var authenticated = false
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Authentication failed: \(error.localizedDescription)")
                self!.authenticated = false
            } else {
                print("Authentication successful")
                if let user = authResult?.user {
                    self!.authenticated = true
                }

            }
        }
    }
    
    func createUser(name: String, email: String, password: String){
        Auth.auth().createUser(withEmail: email, password: password) { authResult, error in
            if let error = error {
                print("\(password)")
                print("Error creating user: \(error.localizedDescription)")
                return
            }

            if let user = authResult?.user {
                let uid = user.uid
                do{
                    let newUser = UserModel(id: "\(uid)", name: name, email: email, password: password, image: "https://firebasestorage.googleapis.com/v0/b/mc2-studybuddy.appspot.com/o/users%2Fuser.png?alt=media&token=263b2e43-e206-45d6-a75f-7f7170063e41", category: [], badges: [])
                    try self.db.collection("users").document(newUser.id).setData(from: newUser)
                }catch{
                    print("Error create user: \(error)")
                }
            }
        }
    }
    
    func checkLogin(email: String, password: String) -> Bool{
        return email.isEmpty || password.count < 6
    }
    
    func checkRegister(name: String, email: String, password: String) -> Bool{
        return name.isEmpty || email.isEmpty || password.count < 6
    }
    
}
