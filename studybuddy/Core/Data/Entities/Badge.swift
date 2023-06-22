//
//  Badge.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

class Badge: Identifiable, Codable {
    var id: String = UUID().uuidString
    var name: String?
    var image: String?
    var description: String?
}
