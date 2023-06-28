//
//  UserViewModel.swift
//  studybuddy
//
//  Created by Kezia Gloria on 28/06/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

class UserViewModel: ObservableObject {
    
    @Published var users = [UserModel]()
    
    var db = Firestore.firestore()
    
    func getUser(id: String, completion: @escaping (UserModel?) -> Void){
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
                let badges = data?["badges"] as? [String] ?? []
                let category = data?["category"] as? [String] ?? []
                let user = UserModel(id: documentID, name: name, email: email, password: password, image: image, category: category, badges: badges)
                
                print("Retrieved user: \(user)")
                completion(user)
            } else {
                print("User document does not exist")
                completion(nil)
            }
        }
    }
    
}
