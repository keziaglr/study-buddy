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
    
    func updateBadges(badge: String) async throws{
        guard let userID = currentUser?.id else {
            return
        }
        try await dbRef.document(userID).updateData([
            "badges" : FieldValue.arrayUnion([badge])
        ])
        currentUser?.badges.append(badge)
    }
    
    func updateUserInterest(category: [String]) async throws{
        guard let userID = currentUser?.id else {
            return
        }
        try await dbRef.document(userID).updateData([
            "category" : category
        ])
        currentUser?.category = category
    }
    
    func updateProfileImage(image: String) async throws{
        guard let userID = currentUser?.id else {
            return
        }
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
    
    func updateCommunity(communities: [String]) async throws {
        guard let userID = currentUser?.id else {
            return
        }
        try await dbRef.document(userID).updateData([
            "communities" : communities
        ])
        currentUser?.communities = communities
    }
    
    func getUser(userID: String) async throws -> UserModel {
        return try await dbRef.document(userID).getDocument(as: UserModel.self)
    }
}
