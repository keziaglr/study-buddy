//
//  UserViewModel.swift
//  studybuddy
//
//  Created by Kezia Gloria on 28/06/23.
//

import SwiftUI
import Foundation

@MainActor
class UserViewModel: ObservableObject {
    
    var userManager = UserManager.shared
    
    func getUser(userID: String) async throws -> UserModel {
        return try await userManager.getUser(userID: userID)
    }
    
    func updateUserInterest(categories: Set<String>) async throws {
        guard let _ = userManager.currentUser?.id else {
            print("User is not authenticated or user ID could not be retrieved.")
            return
        }
        
        try await UserManager.shared.updateUserInterest(category: Array(categories))
//        self.currentUser?.category = Array(categories)
    }
    
    func uploadUserProfile(localURL: URL) async throws{
        guard let currentUser = userManager.currentUser else {
            print("No user model")
            return
        }
        
        if currentUser.image != "" {
            StorageManager.shared.deleteUserProfileImage(downloadURL: currentUser.image)
        }
        
        let downloadURL = try await StorageManager.shared.saveUserProfileImage(url: localURL)
        try await UserManager.shared.updateProfileImage(image: downloadURL.absoluteString)
//        self.currentUser?.image = downloadURL.absoluteString
    }
    
}
