//
//  ChatViewModel.swift
//  studybuddy
//
//  Created by Kezia Gloria on 28/06/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

final class ChatViewModel: ObservableObject {
    
    @Published private(set) var chats : [Chat] = []
    @Published private(set) var lastmessageID = ""
    @Published private var um = UserViewModel()
    
    let db = Firestore.firestore()
    
    func getChats(communityID: String) -> [Chat]{
        db.collection("communities").document(communityID).collection("chats").addSnapshotListener { querySnapshot, error in
            guard let documents = querySnapshot?.documents else {
                print("Error fetching data \(String(describing: error))")
                return
            }
            
            self.chats = documents.compactMap{ document -> Chat? in
                do{
                    return try document.data(as : Chat.self)
                }catch{
                    print("Error decoding document into message \(String(describing: error))")
                    return nil
                }
            }
            
            self.chats.sort{ $0.dateCreated < $1.dateCreated}
            
            if let id = self.chats.last?.id {
                self.lastmessageID = id
            }
            
        }
        return chats
    }
    
    func sendChats(text: String, communityID: String){
        um.getUser(id: Auth.auth().currentUser?.uid ?? "") { user in
            if let user = user {
                let newChat = Chat(id: "\(UUID())", content: text, dateCreated: Date(), user: user.id)
                
                do {
                    try self.db.collection("communities").document(communityID).collection("chats").document(newChat.id).setData(from: newChat)
                } catch {
                    print("Error sending chat: \(error)")
                }
            } else {
                print("Failed to retrieve user")
            }
        }

    }
    
}
