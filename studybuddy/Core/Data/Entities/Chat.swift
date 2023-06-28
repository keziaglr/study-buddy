//
//  Chat.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable{
    var id: String
    var content: String
    var dateCreated: Date
    var user: String
}
