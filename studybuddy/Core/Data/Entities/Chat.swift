//
//  Chat.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

class Chat: Identifiable, Codable{
    var id: String = UUID().uuidString
    var content: String?
    var dateCreated: Date?
    var user: User?
}
