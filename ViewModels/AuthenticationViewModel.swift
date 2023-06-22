//
//  AuthenticationViewModel.swift
//  studybuddy
//
//  Created by Kezia Gloria on 23/06/23.
//

import Foundation
import FirebaseFirestore
import FirebaseAuth

final class AuthenticationViewModel : ObservableObject {
    
    let db = Firestore.firestore()
    
    func auth(email: String, password: String){
        Auth.auth().signIn(withEmail: email, password: password) { [weak self] authResult, error in
            guard let strongSelf = self else { return }
            if let error = error {
                print("Authentication failed: \(error.localizedDescription)")
            } else {
                print("Authentication successful")
                if let user = authResult?.user {
                    //TODO: Redirect to HOME
                    
//                    if Auth.auth().currentUser != nil {
//                        //Buat dapat uid current user
//                        print("Current User \(Auth.auth().currentUser?.uid)")
//                    }
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
                    //TODO: Change image placeholder
                    let newUser = UserModel(id: "\(uid)", name: name, email: email, password: password, image: "gs://mc2-studybuddy.appspot.com/communities/ab6761610000e5eb006ff3c0136a71bfb9928d34.jpeg", badges: [])
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
