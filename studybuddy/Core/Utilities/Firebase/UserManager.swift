//
//  UserManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//


import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class UserManager {
    static let shared = UserManager()
    private let dbRef = Firestore.firestore().collection("users")
    func addUser(user: UserModel) {
        do {
            try dbRef.document(user.id!).setData(from: user)
        } catch {
            print(error)
        }
    }
     
    func updateUserInterest(userID: String, category: [String]) async throws{
        try await dbRef.document(userID).updateData([
            "category" : category
        ])
    }
    
    func updateProfileImage(userID: String, image: String) async throws{
        try await dbRef.document(userID).updateData([
            "image" : image
        ])
    }
    
    func getCurrentUser(userID: String) async throws -> UserModel? {
        let docRef = dbRef.document(userID)
        return try await docRef.getDocument(as: UserModel.self)
    }
}
