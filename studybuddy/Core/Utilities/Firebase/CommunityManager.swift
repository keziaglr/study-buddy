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

    func addCommunity(community: Community) {
        do {
            try dbRef.document().setData(from: community)
        } catch {
            print(error)
        }
    }
    
    func getMembers(_ communityID: String) async throws -> [CommunityMember] {
        let querySnapshot = try await dbRef.document(communityID).collection("members").getDocuments()
        let members = querySnapshot.documents.compactMap { document -> CommunityMember? in
            return try? document.data(as: CommunityMember.self)
        }
        return members
    }

    func addMember(_ communityID: String, _ member: CommunityMember) {
        do {
            try dbRef.document(communityID).collection("members").document().setData(from: member)
        } catch {
            print(error)
        }
    }
    
    func deleteMember(_ communityID: String, _ memberID: String) {
        dbRef.document(communityID).collection("members").document(memberID).delete { error in
            if let error = error {
                print(error)
            } else {
                print("success delete member")
            }
        }
    }

    func getUserJoinedCommunity(userID: String) async throws -> [Community] {
        var joinedCommunities: [Community] = []

        do {
            let querySnapshot = try await dbRef.getDocuments()

            for document in querySnapshot.documents {
                let communityID = document.documentID
                let membersRef = dbRef.document(communityID).collection("members") // Corrected line
                let query = membersRef.whereField("id", isEqualTo: userID)

                let membersQuerySnapshot = try await query.getDocuments()

                if !membersQuerySnapshot.isEmpty {
                    let community = try document.data(as: Community.self)
                    joinedCommunities.append(community)
                }
            }
        } catch {
            throw error
        }

        return joinedCommunities
    }
    
    func setCommunitySchedule(communityID: String, data: [String : Any]) async throws {
        try await dbRef.document(communityID).updateData(data)
    }
    
}
