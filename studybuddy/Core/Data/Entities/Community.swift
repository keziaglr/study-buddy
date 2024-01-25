//
//  Community.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Community: Identifiable, Codable{
    @DocumentID var id: String?
    var title: String
    var description: String
    var image: String
    var category: String
    var startDate: Date?
    var endDate: Date?
    var members: Int?
    
    static let previewDummy = Community(id: "86EYeOOOfXyBCJrHchdD", title: "Belajar Aljabar Dasar", description: "Ayo belajar aljabar bersama", image: "https://firebasestorage.googleapis.com:443/v0/b/mc2-studybuddy.appspot.com/o/communities%2FF1DFC174-3ED4-4A40-9942-24C96D4E0D17.jpeg?alt=media&token=d10482f0-0995-4cc6-a202-775a900c960e", category: "Mathematics", startDate: Date(), endDate: Date().addingTimeInterval(6000))
}
