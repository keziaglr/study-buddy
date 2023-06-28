//
//  User.swift
//  studybuddy
//
//  Created by Kezia Gloria on 21/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct UserModel: Identifiable, Codable {
    var id: String
    var name: String
    var email: String
    var password: String
    var image: String
    var category : [String]
    var badges: [String]
}

struct communityMember: Identifiable, Codable {
    var id: String
    var name: String
//    var badges: [String]
}
