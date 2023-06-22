//
//  Community.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

class Community: Identifiable, Codable{
    var id: String = UUID().uuidString
    var title: String?
    var description: String?
    var image: String?
    var chats: [Chat]?
    var libraries: [Library]?
    var members: [User]?
}
