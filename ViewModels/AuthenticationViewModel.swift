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
                    //TODO: Redirect to HOME
                    self!.authenticated = true
//                    if Auth.auth().currentUser != nil {
//                        //Buat dapat uid current user
//                        print("Current User \(Auth.auth().currentUser?.uid)")
//                    }
                }

            }
        }
//        return authenticated
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
                    let newUser = UserModel(id: "\(uid)", name: name, email: email, password: password, image: "gs://mc2-studybuddy.appspot.com/communities/ab6761610000e5eb006ff3c0136a71bfb9928d34.jpeg", category: [])
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

class UserManager: ObservableObject {

    @Published var users = [UserModel]()

    var db = Firestore.firestore()

    func getUser(id: String, completion: @escaping (UserModel?) -> Void){
        print(id)
        db.collection("users").document(id).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting community: \(error)")
                completion(nil)
                return
            }

            guard let document = documentSnapshot else {
                print("Users document does not exist")
                completion(nil)
                return
            }

            if document.exists {
                let data = document.data()
                let documentID = document.documentID
                let name = data?["name"] as? String ?? ""
                let email = data?["email"] as? String ?? ""
                let password = data?["password"] as? String ?? ""
                let image = data?["image"] as? String ?? ""
                let interest = data?["category"] as? [String] ?? []
                let user = UserModel(id: documentID, name: name, email: email, password: password, image: image, category: interest )
                print("Retrieved user: \(user)")
                completion(user)
            } else {
                print("User document does not exist")
                completion(nil)
            }
        }
    }

}
