//
//  User.swift
//  studybuddy
//
//  Created by Kezia Gloria on 21/06/23.
//

import Foundation
import FirebaseFirestoreSwift
import FirebaseAuth

struct UserModel: Codable {
    @DocumentID var id: String?
    var name: String
    var email: String
    var password: String
    var image: String
    var category: [String]
    var badges: [String]
    var communities: [String]
    
    enum Preferences: String {
        case category
    }
    
    static let previewDummy = UserModel(id: "DWZEQwcVoPhGb9NMDrPTi5UluUy1", name: "Test User", email: "Test123@gmail.com", password: "123456", image: "https://firebasestorage.googleapis.com:443/v0/b/mc2-studybuddy.appspot.com/o/users%2F23012024-E0308C8E-2605-4EC8-B629-69ABC963635C.jpeg?alt=media&token=72e7390f-5b0a-42f1-9eaa-90500a5f8eaf", category: ["Literature", "Information Technology", "Law"], badges: ["Engaged Explorer"], communities: ["86EYeOOOfXyBCJrHchdD"])
}

