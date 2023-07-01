//
//  ChatTemp.swift
//  studybuddy
//
//  Created by Kezia Gloria on 24/06/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
 
class BadgeViewModel: ObservableObject {
    
    @Published var badges = [Badge]()
    @Published private var um = UserViewModel()
    
    var db = Firestore.firestore()
    
    init() {
        getBadges()
    }
    
    func getBadgeID(badgeName: String) -> String {
        let badgeID = self.badges.first { badge in
            badge.name == badgeName
        }
        return badgeID!.id
    }
    
    func validateBadge(badgeId: String, completion: @escaping (Bool) -> Void) {
        guard let currentUserID = Auth.auth().currentUser?.uid else {
            completion(false)
            return
        }

        um.getUser(id: currentUserID) { user in
            var isValid = false
            if let currUser = user {
                isValid = user!.badges.contains(badgeId)
            }

            completion(isValid)
        }
    }
    
    func getBadge(id: String, completion: @escaping (Badge?) -> Void){
        db.collection("badges").document(id).getDocument { (documentSnapshot, error) in
            if let error = error {
                print("Error getting community: \(error)")
                completion(nil)
                return
            }
            
            guard let document = documentSnapshot else {
                print("Badges document does not exist")
                completion(nil)
                return
            }
            
            if document.exists {
                let data = document.data()
                let documentID = document.documentID
                let name = data?["name"] as? String ?? ""
                let image = data?["image"] as? String ?? ""
                let description = data?["description"] as? String ?? ""
                let badge = Badge(id: documentID, name: name, image: image, description: description)
                
                print("Retrieved user: \(badge)")
                completion(badge)
            } else {
                print("User document does not exist")
                completion(nil)
            }
        }
    }
    
    func achieveBadge(badgeId: String){
        um.getUser(id: Auth.auth().currentUser?.uid ?? "") { [self] user in
            let collectionRef = db.collection("users")
            let documentRef = collectionRef.document(user?.id ?? "")
            documentRef.getDocument { (document, error) in
                if let document = document, document.exists {
                    if let data = document.data(), let existingArray = data["badges"] as? [String] {
                        var newArray = existingArray
                        
                        if !newArray.contains(badgeId){
                            newArray.append(badgeId)
                            
                            documentRef.updateData(["badges": newArray]) { error in
                                if let error = error {
                                    print("Error updating array: \(error.localizedDescription)")
                                } else {
                                    print("Array updated successfully")
                                }
                            }
                        }
                    } else {
                        print("Existing array not found in the document")
                    }
                } else {
                    print("Document does not exist")
                }
            }
        }
    }
    
    func getBadges(){
        db.collection("badges").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching data \(String(describing: error))")
                return
            }
            
            self.badges = documents.compactMap{ (queryDocumentSnapshot) -> Badge in
                let documentID = queryDocumentSnapshot.documentID
                let data = queryDocumentSnapshot.data()
                let name = data["name"] as? String ?? ""
                let image = data["image"] as? String ?? ""
                let description = data["description"] as? String ?? ""
                return Badge(id: documentID, name: name, image: image, description: description)
            }
        }
    }
}
