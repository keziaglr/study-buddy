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
    @Published private var bm = BadgeViewModel()
    @Published var showAchievedScholarSupremeBadge = false
    @Published var badgeImageURL = ""
    
    
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
                let newChat = Chat(id: "\(UUID())", content: text, dateCreated: Date(), user: user.id!)
                
                // TODO: fix achieve badge
//                self.bm.validateBadge(badgeId: self.getScholarSupremeBadgeID()) { hasBadge in
//                    if !hasBadge && self.isFirstChatOfTheDay(newChat: newChat){
//                        self.checkScholarSupremeBadge()
//                    }
//                }
                
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
    
    func isFirstChatOfTheDay(newChat: Chat) -> Bool {
        guard let lastChat = chats.last else {
            return true // If there are no previous chats, consider it the first chat of the day
        }
        
        let calendar = Calendar.current
        let newChatDate = calendar.dateComponents([.year, .month, .day], from: newChat.dateCreated)
        let lastChatDate = calendar.dateComponents([.year, .month, .day], from: lastChat.dateCreated)
        
        return newChatDate != lastChatDate
    }

    func getScholarSupremeBadgeID() -> String {
        return bm.getBadgeID(badgeName: "Scholar Supreme")
    }

    
    func checkScholarSupremeBadge() {
        // Sort the chats array by dateCreated in descending order
        
        let currentUserChats = chats.filter { $0.user == Auth.auth().currentUser?.uid }
        
        let sortedChats = currentUserChats.sorted { $0.dateCreated > $1.dateCreated }
        
        var uniqueChats: [Chat] = []
        var previousDate: Date?
        
        let calendar = Calendar.current
        
        for chat in sortedChats {
            let currentDate = calendar.startOfDay(for: chat.dateCreated)
            if currentDate != previousDate {
                uniqueChats.append(chat)
                previousDate = currentDate
            }
        }

        // Get the latest date of the first chat
        guard let startDate = uniqueChats.first?.dateCreated else {
            // Handle the case where there are no chats
            return
        }

        // Iterate over the sorted chats array and check if there is a chat for each consecutive day
        // Check if there are at least 7 consecutive days
        var currentDate = startDate
        var consecutiveCount = 0

        for chat in uniqueChats {
            // Check if the current chat's date is the same as the current date
            if calendar.isDate(chat.dateCreated, inSameDayAs: currentDate) {
                consecutiveCount += 1
                if consecutiveCount == 7 {
                    // User has been chatting for 7 consecutive days
                    print("User has been chatting for 7 consecutive days until \(chat.dateCreated)")
                    bm.achieveBadge(badgeId: getScholarSupremeBadgeID())
                    // TODO: fix achieve badge
//                    bm.getBadge(id: getScholarSupremeBadgeID()) { [self] badge in
//                        badgeImageURL  = badge!.name
//                        showAchievedScholarSupremeBadge = true
//                    }
                    break
                }
                // Move to the next consecutive day
                currentDate = calendar.date(byAdding: .day, value: -1, to: currentDate)!
            } else {
                // The consecutive pattern is broken, reset the count
                consecutiveCount = 0
            }
        }

        // Check if the user has not reached 7 consecutive days
        if consecutiveCount < 7 {
            print("User has not been chatting for 7 consecutive days")
        }
    }
}
