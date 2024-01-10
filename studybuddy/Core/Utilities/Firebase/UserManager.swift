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
            try dbRef.document().setData(from: user)
        } catch {
            print(error)
        }
    }
}
