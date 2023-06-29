//
//  CommunityViewModel.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 25/06/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

class CommunityViewModel: ObservableObject {
    
    @Published var userManager = UserManager()
    @Published var communities = [Community]()
    @Published var members = [communityMember]()
    var db = Firestore.firestore()
    
    // MARK: - Community Operations
    
    func getCommunity() {
        db.collection("communities").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            let communities = documents.compactMap { (queryDocumentSnapshot) -> Community? in
                let documentID = queryDocumentSnapshot.documentID
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return Community(id: documentID, title: title, description: description, image: image, category: category)
            }
            
            DispatchQueue.main.async {
                self?.communities = communities
            }
        }
    }
    
    func addCommunity(title: String, description: String, image: String, category: String) {
        let uid = UUID().uuidString
        
        do {
            let newCommunity = Community(id: uid, title: title, description: description, image: image, category: category)
            try db.collection("communities").document(uid).setData(from: newCommunity)
        } catch {
            print(error)
        }
    }
    
    func joinCommunity(communityID: String) {
        userManager.getUser(id: Auth.auth().currentUser?.uid ?? "") { [weak self] user in
            if let user = user {
                let newMember = communityMember(id: user.id, name: user.name)
                
                let membersRef = self?.db.collection("communities").document(communityID).collection("members")
                
                membersRef?.whereField("id", isEqualTo: user.id).getDocuments { [weak self] (querySnapshot, error) in
                    if let error = error {
                        print("Error checking community members: \(error.localizedDescription)")
                        return
                    }
                    
                    if let documents = querySnapshot?.documents, !documents.isEmpty {
                        print("You have already joined this community.")
                        return
                    }
                    
                    membersRef?.getDocuments(completion: { (snapshot, error) in
                        if let error = error {
                            print("Error checking community member count: \(error.localizedDescription)")
                            return
                        }
                        
                        if let memberCount = snapshot?.documents.count, memberCount >= 6 {
                            print("The community already has 6 members. You cannot join at the moment.")
                            return
                        }
                        
                        do {
                            try membersRef?.document().setData(from: newMember)
                            print("Successfully joined the community")
                        } catch {
                            print("Error joining community: \(error.localizedDescription)")
                        }
                    })
                }
            } else {
                print("No user found")
            }
        }
    }

    func removeMemberFromCommunity(communityID: String) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return
        }
        
        let membersRef = db.collection("communities").document(communityID).collection("members")
        let query = membersRef.whereField("id", isEqualTo: currentUserID)
        
        query.getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error removing member from community: \(error.localizedDescription)")
            } else {
                if let document = querySnapshot?.documents.first {
                    membersRef.document(document.documentID).delete { error in
                        if let error = error {
                            print("Error removing member from community: \(error.localizedDescription)")
                        } else {
                            print("Member removed successfully")
                        }
                    }
                } else {
                    print("Member not found in the community")
                }
            }
        }
    }
    
    func getJoinedCommunity() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return
        }
        
        let communitiesRef = db.collection("communities")
        
        communitiesRef.getDocuments { [weak self] (querySnapshot, error) in
            if let error = error {
                print("Error getting community documents: \(error)")
                return
            }
            
            guard let documents = querySnapshot?.documents else {
                print("No matching communities found")
                return
            }
            
            var joinedCommunities = [Community]() // Create an empty array to store joined communities
            
            for document in documents {
                let communityID = document.documentID
                let membersRef = communitiesRef.document(communityID).collection("members")
                
                membersRef.whereField("id", isEqualTo: userId).getDocuments { [weak self] (membersSnapshot, membersError) in
                    if let membersError = membersError {
                        print("Error getting members documents: \(membersError)")
                        return
                    }
                    
                    if let membersDocument = membersSnapshot?.documents.first {
                        let data = document.data()
                        
                        let id = membersDocument.documentID
                        let title = data["title"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let image = data["image"] as? String ?? ""
                        let category = data["category"] as? String ?? ""
                        
                        let community = Community(id: communityID, title: title, description: description, image: image, category: category)
                        
                        joinedCommunities.append(community) // Add the joined community to the array
                        
                        print("Community ID: \(communityID), Title: \(title), Description: \(description), Image: \(image)")
                    }
                        DispatchQueue.main.async {
                            self?.communities = joinedCommunities
                    }
                }
            }
        }
    }

    func getMembers(communityId: String) {
        db.collection("communities").document(communityId).collection("members").addSnapshotListener { [weak self] (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            let members = documents.compactMap { (queryDocumentSnapshot) -> communityMember? in
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let id = data["id"] as? String ?? ""
                print(name)
                print(id)
                return communityMember(id: id, name: name)
                
                
            }
            
            DispatchQueue.main.async {
                self?.members = members
            }
        }
    }
    
    func getRecommendation(){
        
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return
        }
        
        userManager.getUser(id: currentUserID) { user in
            
            if let interest = user?.category{
                
                self.db.collection("communities").whereField("category", in: interest).getDocuments { (querySnapshot,error) in
                    guard let documents = querySnapshot?.documents else {
                        print("no matching communtiies found")
                        return
                    }
                    
                    let communities = documents.compactMap { (queryDocumentSnapshot) -> Community? in
                        let documentID = queryDocumentSnapshot.documentID
                        let data = queryDocumentSnapshot.data()
                        let title = data["title"] as? String ?? ""
                        let description = data["description"] as? String ?? ""
                        let image = data["image"] as? String ?? ""
                        let category = data["category"] as? String ?? ""
                        return Community(id: documentID, title: title, description: description, image: image, category: category)
                    }
                    
                    DispatchQueue.main.async {
                        self.communities = communities
                    }
                    print("Matching Communities: \(communities)")
                }
                
            }
      
        }
    }
    
}
