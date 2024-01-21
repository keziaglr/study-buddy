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
}

