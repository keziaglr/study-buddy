//
//  UserManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//


import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

@MainActor
final class UserManager: ObservableObject {
    static let shared = UserManager()
    @Published var currentUser: UserModel?
    private let dbRef = Firestore.firestore().collection("users")
    func addUser(user: UserModel) {
        do {
            try dbRef.document(user.id!).setData(from: user)
            currentUser = user
        } catch {
            print(error)
        }
    }
     
    func updateUserInterest(userID: String, category: [String]) async throws{
        try await dbRef.document(userID).updateData([
            "category" : category
        ])
        currentUser?.category = category
    }
    
    func updateProfileImage(userID: String, image: String) async throws{
        try await dbRef.document(userID).updateData([
            "image" : image
        ])
        currentUser?.image = image
    }
    
    func getCurrentUser() async throws {
        guard let userID = Auth.auth().currentUser?.uid else{
            print("no user")
            return
        }
        let docRef = dbRef.document(userID)
        currentUser = try await docRef.getDocument(as: UserModel.self)
    }
}
