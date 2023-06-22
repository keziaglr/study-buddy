//
//  User.swift
//  studybuddy
//
//  Created by Kezia Gloria on 21/06/23.
//

import Foundation
import FirebaseFirestoreSwift

class User: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String?
    var email: String?
    var password: String?
    var image: String?
    var badges: [Badge]?
}
