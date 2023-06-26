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

class CommunityViewmodel : ObservableObject {
    
    @Published var userManager = UserManager()
    @Published var communities = [Community]()
    var db = Firestore.firestore()
    
    
    func getCommunity() {
        db.collection("communities").addSnapshotListener { (querySnapshot, error) in
            guard let documents = querySnapshot?.documents else {
                print("No Documents")
                return
            }
            
            self.communities = documents.map { (queryDocumentSnapshot) -> Community in
                let documentID = queryDocumentSnapshot.documentID
                let data = queryDocumentSnapshot.data()
                let title = data["title"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                let category = data["category"] as? String ?? ""
                return Community(id: documentID, title: title, description: description, image: image, category: category)
                
            }
        }
    }
    
    func addCommunity(Title: String, Description: String, Image: String, category: String){
        do{
            let newCommunity = Community(id: "\(UUID())", title: Title, description: Description, image: Image, category: category)
            try db.collection("communities").document().setData(from: newCommunity)
        }catch{
            print(error)
        }
    }
    
    
    
    func joinCommunity(communityID: String){
        userManager.getUser(id: Auth.auth().currentUser?.uid ?? "") { user in
            if let user = user {
                let newMember = communityMember(id: user.id, name: user.name)
                
                do{
                    try self.db.collection("communities").document(communityID).collection("members").document().setData(from: newMember)
                }catch{
                    print("Error joining community")
                }
            }else{
                print("No user found")
            }
        }
    }
    
    func removeMemberFromCommunity(communityID: String) {
        if let currentUserID = Auth.auth().currentUser?.uid {
            let membersRef = self.db.collection("communities").document(communityID).collection("members")
            let query = membersRef.whereField("id", isEqualTo: currentUserID)
            
            query.getDocuments { (querySnapshot, error) in
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
        } else {
            print("User is not authenticated or user ID could not be retrieved.")
        }
    }
    
    func getJoinedCommunity(){
        if let currentUserId = Auth.auth().currentUser?.uid{
            let membersRef = self.db.collection("communities").document().collection("members")
            let query = membersRef.whereField("id", isEqualTo: currentUserId)
            
            query.getDocuments { querySnapshot, error in
                guard let documents = querySnapshot?.documents else {
                    print("No Documents")
                    return
                }
                
                self.communities = documents.map { (queryDocumentSnapshot) -> Community in
                    let documentID = queryDocumentSnapshot.documentID
                    let data = queryDocumentSnapshot.data()
                    let title = data["title"] as? String ?? ""
                    let image = data["image"] as? String ?? ""
                    let description = data["description"] as? String ?? ""
                    let category = data["category"] as? String ?? ""
                    return Community(id: documentID, title: title, description: description, image: image, category: category)
                    
                }
            }
                
        }
    }
    
    
    
}
