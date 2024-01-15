//
//  Badge.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Badge: Identifiable, Codable {
    @DocumentID var id: String?
    var name: String
    var image: String
    var description: String
}
