//
//  Chat.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Chat: Identifiable, Codable{
    @DocumentID var id: String?
    var content: String
    var dateCreated: Date
    var user: String
    
    static let previewDummy = Chat(id: "nIxePief0BMpG8ytuIdf", content: "Ajarin aku aljabar dong", dateCreated: Date(), user: "DWZEQwcVoPhGb9NMDrPTi5UluUy1")
}
