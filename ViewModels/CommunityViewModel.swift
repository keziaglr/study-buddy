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
import FirebaseStorage

class CommunityViewModel: ObservableObject {
    @Published var memberCount: Int = 0
    
    @Published var userManager = UserViewModel()
    @Published var bvm = BadgeViewModel()
    @Published var communities = [Community]()
    @Published var jCommunities = [Community]()
    @Published var rcommunities = [Community]()
    @Published var members = [communityMember]()
    let storageRef = Storage.storage().reference()
    @Published var badge = ""
    @Published var showBadge = false
    var db = Firestore.firestore()
    
    init() {
        getJoinedCommunity()
        getCommunity()
    }
    
    func dateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"//"EE" to get short style
        let mydt = dateFormatter.string(from: date).capitalized
        
        return "\(mydt)"
    }
    
    func getCommunity(id: String, completion: @escaping (Community?) -> Void){
        db.collection("communities").document(id).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting community: \(error)")
                completion(nil)
                return
            }
            guard let document = documentSnapshot else {
                print("Communities document does not exist")
                completion(nil)
                return
            }
            
            if document.exists {
                let data = document.data()
                let documentID = document.documentID
                let title = data?["title"] as? String ?? ""
                let image = data?["image"] as? String ?? ""
                let description = data?["description"] as? String ?? ""
                let category = data?["category"] as? String ?? ""
                let community = Community(id: documentID, title: title, description: description, image: image, category: category)
                
                print("Retrieved user: \(community)")
                completion(community)
            } else {
                print("Communities document does not exist")
                completion(nil)
            }
        }
    }
    
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
    
    func addCommunity(title: String, description: String, url: URL, category: String) {
        let uid = UUID().uuidString
        let date = dateFormatting()
        let filePath = "\(date)-\(url.lastPathComponent)"
        storageRef.child("communities").child(filePath).putFile(from: url, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading file to Firebase Storage: \(error.localizedDescription)")
            } else {
                print("File uploaded successfully.")
                
                self.storageRef.child("communities/\(filePath)").downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else if let downloadURL = url {
                        print("Download URL: \(downloadURL.absoluteString)")
                        do {
                            let newCommunity = Community(id: uid, title: title, description: description, image: downloadURL.absoluteString, category: category)
                            try self.db.collection("communities").document(uid).setData(from: newCommunity)
                        } catch {
                            print(error)
                        }
                    }
                }
            }
        }
    }
    
    func joinCommunity(communityID: String) {
        userManager.getUser(id: Auth.auth().currentUser?.uid ?? "") { [weak self] user in
            if let user = user {
                let newMember = communityMember(id: user.id, name: user.name, image: user.image)
                
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
                            
                            self!.validateBadge(communityID: communityID)
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
    
    func validateBadge(communityID: String){
        if jCommunities.count == 2 {
            bvm.validateBadge(badgeId: "ucwbWJ8b86D1yS3a3gWD") { b in
                if !b{
                    self.showBadge = true
                    self.badge = "https://firebasestorage.googleapis.com/v0/b/mc2-studybuddy.appspot.com/o/badges%2FLearning%20Luminary.png?alt=media&token=2a8f8697-913b-4daa-a68f-6e2e2d49386d"
                    self.bvm.achieveBadge(badgeId: "ucwbWJ8b86D1yS3a3gWD")
                }
            }
        }else {
            getCommunity(id: communityID) { c in
                for jc in self.jCommunities {
                    if jc.category != c?.category{
                        self.bvm.validateBadge(badgeId: "k8MdhLedia7wj4nbZ0D9") { b in
                            if !b{
                                self.showBadge = true
                                self.badge = "https://firebasestorage.googleapis.com/v0/b/mc2-studybuddy.appspot.com/o/badges%2FEngaged%20Explorer.png?alt=media&token=5e4d4f27-74ec-4b43-b61d-6f57ad897cde"
                                self.bvm.achieveBadge(badgeId: "k8MdhLedia7wj4nbZ0D9")
                            }
                        }
                    }
                }
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
                        self?.jCommunities = joinedCommunities
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
                let image = data["image"] as? String ?? ""
                print(name)
                print(id)
                return communityMember(id: id, name: name, image: image)
            }
            DispatchQueue.main.async {
                self?.members = members
                self?.memberCount = members.count
            }
        }
    }
    
    func getRecommendation() {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            print("User is not authenticated or user ID could not be retrieved.")
            return
        }
        
        userManager.getUser(id: currentUserID) { user in
            
            if let interest = user?.category {
                self.db.collection("communities").whereField("category", in: interest).getDocuments { (querySnapshot, error) in
                    if let error = error {
                        print("Error getting community documents: \(error)")
                        return
                    }
                    
                    guard let documents = querySnapshot?.documents else {
                        print("No matching communities found")
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
                        self.rcommunities = communities
                    }
                    
                    print("Matching Communities: \(communities)")
                }
            }
        }
    }
    
    
}
