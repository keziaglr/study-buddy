//
//  Library.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Library: Identifiable, Codable{
    var id: String
    var url: String
    var dateCreated: Date
    var type: String
}
