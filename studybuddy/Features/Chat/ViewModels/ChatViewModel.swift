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

@MainActor
final class ChatViewModel: ObservableObject {
    
    @Published var chats : [Chat] = []
    @Published var lastmessageID = ""
    @Published var showAchievedScholarSupremeBadge = false
    @Published var showedBadge: Badge?
    var currentUser = UserManager.shared.currentUser
    var badgeManager = BadgeManager.shared
    
    
    func getChats(communityID: String) {
        lastmessageID = ""
        chats = []
        ChatManager.shared.listenNewChat(communityID: communityID) { chat, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let newChat = chat else {
                print("new chat error")
                return
            }
            
            self.chats.append(newChat)
            self.chats.sort{ $0.dateCreated < $1.dateCreated}
            if let id = self.chats.last?.id {
                self.lastmessageID = id
            }
        }
    }
    
    func sendChats(text: String, communityID: String) {
        guard let user = currentUser else {
            print("no user")
            return
        }
        let newChat = Chat(content: text, dateCreated: Date(), user: user.id!)
        
        //MARK: SCHOLAR SUPREME BADGE
        let hasBadge = badgeManager.validateBadge(badgeName: Badges.scholarSupereme)
        
        if hasBadge && isFirstChatOfTheDay(newChat: newChat) {
            Task {
                do {
                    try await checkScholarSupremeBadge()
                } catch {
                    print(error)
                }
            }
            
        }
        ChatManager.shared.sendChat(chat: newChat, communityID: communityID)
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
        return badgeManager.getBadgeID(badgeName: "Scholar Supreme")
    }

    
    func checkScholarSupremeBadge() async throws {
        // Sort the chats array by dateCreated in descending order
        
        let currentUserChats = chats.filter { $0.user == currentUser?.id } // get all user chat in the chat room
        
        if currentUserChats.count < 7 {
            print("User's chats are less than 7")
            return
        }
        
        let sortedChats = currentUserChats.sorted { $0.dateCreated > $1.dateCreated } // sort that chat
        
        var uniqueChats: [Chat] = [] // this is to get only 1 chat for each day so we dont check too much
        var previousDate: Date?
        
        let calendar = Calendar.current
        
        for chat in sortedChats {
            let currentDate = calendar.startOfDay(for: chat.dateCreated)
            if currentDate != previousDate {
                uniqueChats.append(chat)
                previousDate = currentDate
            }
        }

        // Get the latest DATE of the first chat
        guard let startDate = uniqueChats.first?.dateCreated else {
            // Handle the case where there are no chats
            return
        }

        // Iterate over the sorted  unique chats array and check if there is a chat for each consecutive day
        // Check if there are at least 7 consecutive days
        var currentDate = startDate // a variable to iterate from the first date until the 7th date
        var consecutiveCount = 0

        for chat in uniqueChats {
            // Check if the current chat's date is the same as the current date
            if calendar.isDate(chat.dateCreated, inSameDayAs: currentDate) {
                consecutiveCount += 1
                if consecutiveCount == 7 {
                    // User has been chatting for 7 consecutive days
                    print("User has been chatting for 7 consecutive days until \(chat.dateCreated)")
                    try await badgeManager.achieveBadge(badgeName: Badges.scholarSupereme)
                    let badge = badgeManager.getBadge(badgeName: Badges.scholarSupereme)
                    showedBadge = badge
                    showAchievedScholarSupremeBadge = true
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
