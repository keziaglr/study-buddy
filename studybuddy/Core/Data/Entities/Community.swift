//
//  Community.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Community: Identifiable, Codable{
    var id: String
    var title: String
    var description: String
    var image: String
    var chats: [Chat]
    var libraries: [Library]
    var members: [UserModel]
}
