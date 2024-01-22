//
//  ChatManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 19/01/24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class ChatManager {
    static let shared = ChatManager()
    
    func chatRef(communityID: String) -> CollectionReference {
        return Firestore.firestore().collection("communities").document(communityID).collection("chats")
    }
    
    func sendChat(chat: Chat, communityID: String) {
        do {
            try chatRef(communityID: communityID).document().setData(from: chat)
        } catch {
            print(error)
        }
    }
    
    func getChats(communityID: String) async throws -> [Chat] {
        var chats: [Chat] = []
        let snapshot = try await chatRef(communityID: communityID).getDocuments()
        for document in snapshot.documents {
            let chat = try document.data(as: Chat.self)
            chats.append(chat)
        }
        return chats
    }
    
    func getLatestChat(communityID: String) async throws -> Chat? {
        let latestChatQuery = chatRef(communityID: communityID)
            .order(by: "dateCreated", descending: true)
            .limit(to: 1)
        let snapshot = try await latestChatQuery.getDocuments()
        guard let document = snapshot.documents.first else {
            print("No chats found")
            return nil
        }

        // Access the data of the latest chat document
        let chat = try document.data(as: Chat.self)
        
        return chat
    }
    
    func listenNewChat(communityID: String, completion: @escaping (Chat?, Error?) -> Void) {
        chatRef(communityID: communityID).addSnapshotListener { querySnapshot, error in
            if let error = error {
                print("Error fetching snapshots: \(error)")
                completion(nil, error)
                return
            }

            guard let snapshot = querySnapshot else {
                print("Snapshot is nil.")
                return
            }

            for diff in snapshot.documentChanges {
                if diff.type == .added {
                    do {
                        if let chat = try diff.document.data(as: Chat?.self) {
                            completion(chat, nil)
                        }
                    } catch {
                        print("Error decoding chat: \(error)")
                        completion(nil, error)
                    }
                }
            }
        }
    }
    
    func getUnreadChatCount(communityID: String, lastOpenedDate: Date) async throws -> Int {
        let unreadChatQuery = chatRef(communityID: communityID)
            .whereField("dateCreated", isGreaterThan: Timestamp(date: lastOpenedDate))
        do {
            let querySnapshot = try await unreadChatQuery.getDocuments()
            let unreadChatCount = querySnapshot.documents.count
            return unreadChatCount
        } catch {
            throw error
        }
    }

}
