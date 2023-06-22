//
//  Library.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

class Library: Identifiable, Codable{
    var id: String = UUID().uuidString
    var url: String?
    var dateCreated: Date?
}
