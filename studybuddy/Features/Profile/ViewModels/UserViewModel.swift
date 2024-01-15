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
    
    func getUserProfile() async throws -> UserModel? {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return nil
        }
        
        return try await UserManager.shared.getCurrentUser(userID: currentUserID)
    }
    
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
    
    func updateCategory(category:String){
       
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return
        }
        
        db.collection("users").document(currentUserID).updateData(["category" : FieldValue.arrayUnion([category])])
    }
    
    func updateUserInterest(categories: Set<String>) async throws {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return
        }
        
        try await UserManager.shared.updateUserInterest(userID: currentUserID, category: Array(categories))
    }
    
    func deleteCategory(categoryToDelete: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return
        }
        
        let categoryField = "category"
        
        db.collection("users").document(currentUserID).getDocument { documentSnapshot, error in
            if let error = error {
                print("Error getting document: \(error)")
                return
            }
            
            guard let document = documentSnapshot else {
                print("Document does not exist")
                return
            }
            
            if let categoryArray = document.data()?[categoryField] as? [String], categoryArray.contains(categoryToDelete) {
                let updatedCategoryArray = categoryArray.filter { $0 != categoryToDelete }
                
                let data: [String: Any] = [
                    categoryField: updatedCategoryArray
                ]
                
                self.db.collection("users").document(currentUserID).updateData(data) { error in
                    if let error = error {
                        print("Error deleting category: \(error)")
                    } else {
                        print("Category deleted successfully.")
                    }
                }
            } else {
                print("Category does not exist in the document.")
            }
        }
    }

    
}
