//
//  BadgeManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 15/01/24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class BadgeManager {
    static let shared = BadgeManager()
    private let dbRef = Firestore.firestore().collection("badges")
     
    func getBadges() async throws -> [Badge] {
        var badges: [Badge] = []
        let snapshot = try await dbRef.getDocuments()
        for document in snapshot.documents {
            var badge = try document.data(as: Badge.self)
            badges.append(badge)
        }
        return badges
    }
}
