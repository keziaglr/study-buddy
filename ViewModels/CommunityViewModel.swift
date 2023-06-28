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
    
    @Published var userManager = UserViewModel()
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
        do {
            let newCommunity = Community(id: "\(UUID())", title: title, description: description, image: image, category: category)
            try db.collection("communities").document().setData(from: newCommunity)
        } catch {
            print(error)
        }
    }
    
    func joinCommunity(communityID: String) {
        userManager.getUser(id: Auth.auth().currentUser?.uid ?? "") { [weak self] user in
            if let user = user {
                let newMember = communityMember(id: user.id, name: user.name)
                
                do {
                    try self?.db.collection("communities").document(communityID).collection("members").document().setData(from: newMember)
                } catch {
                    print("Error joining community")
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
                        
                        let community = Community(id: id, title: title, description: description, image: image, category: category)
                        
                        DispatchQueue.main.async {
                            self?.communities.append(community)
                        }
                        
                        print("Community ID: \(communityID), Title: \(title), Description: \(description), Image: \(image)")
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
                let documentID = queryDocumentSnapshot.documentID
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
            let name = user?.name
            let id = user?.id
            let email = user?.email
            
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
