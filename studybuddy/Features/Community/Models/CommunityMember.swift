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
    
    static let previewDummy = CommunityMember(documentID: "FpCLGVG7bzGSTeQeNeNk", id: "DWZEQwcVoPhGb9NMDrPTi5UluUy1", name: "Test User", image: "https://firebasestorage.googleapis.com:443/v0/b/mc2-studybuddy.appspot.com/o/users%2F23012024-E0308C8E-2605-4EC8-B629-69ABC963635C.jpeg?alt=media&token=72e7390f-5b0a-42f1-9eaa-90500a5f8eaf")
}
