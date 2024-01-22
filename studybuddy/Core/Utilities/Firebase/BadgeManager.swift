//
//  BadgeManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 15/01/24.
//


import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

@MainActor
class BadgeManager: ObservableObject {
    static let shared = BadgeManager()
    @Published var badges = [Badge]()
    var userManager = UserManager.shared
    
    var db = Firestore.firestore()
    
    init() {
        getBadges()
    }
    
    func getBadgeID(badgeName: String) -> String {
        let badge = self.badges.first { badge in
            badge.name == badgeName
        }
        return badge!.id
    }
    
    func validateBadge(badgeName: String) -> Bool {
        guard let currentUser = userManager.currentUser else {
            return false
        }
        return currentUser.badges.contains(badgeName)
    }
    
    func getBadge(badgeName: String) -> Badge? {
        return badges.first { badge in
            badge.name == badgeName
        }
    }
    
    
    func achieveBadge(badgeName: String) async throws {
        guard let userBadges = userManager.currentUser?.badges else {
            return
        }
        if userBadges.contains(where: {$0 == badgeName}) == true {
            return
        } else {
            try await UserManager.shared.updateBadges(badge: badgeName)
        }
    }
    
    func getBadges(){
        self.badges = Badge.data
    }
}
