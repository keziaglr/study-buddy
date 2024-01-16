//
//  CommunityManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 16/01/24.
//
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class CommunityManager {
    static let shared = CommunityManager()
    private let dbRef = Firestore.firestore().collection("communities")

    func getCommunity(_ id: String) async throws -> Community? {
        let docRef = dbRef.document(id)
        return try await docRef.getDocument(as: Community.self)
    }

    func getCommunities() async throws -> [Community] {
        let querySnapshot = try await dbRef.getDocuments()
        let communities = querySnapshot.documents.compactMap { document -> Community? in
            return try? document.data(as: Community.self)
        }
        return communities
    }

    func addCommunity(community: Community) async throws {
        do {
            try dbRef.document(community.id!).setData(from: community)
        } catch {
            print(error)
        }
    }

    // Add other community-related operations as needed
}
