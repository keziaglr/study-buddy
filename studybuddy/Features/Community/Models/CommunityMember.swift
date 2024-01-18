//
//  CommunityMember.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 16/01/24.
//

import Foundation
import FirebaseFirestoreSwift

struct CommunityMember: Identifiable, Codable {
    @DocumentID var documentID: String?
    var id: String //userID
    var name: String
    var image: String
}
