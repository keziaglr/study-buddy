//
//  Library.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Library: Identifiable, Codable{
    @DocumentID var id: String?
    var url: String //child path in storage, not downloadURL
    var dateCreated: Date
    var type: String
    var user: String
}
