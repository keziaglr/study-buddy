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
    
    static let previewDummy = Library(id: "RPQtXUv6BIllSQnT27OV", url: "libraries/23012024-8FA5C162-4837-405E-955C-CE8346705357.jpeg", dateCreated: Date(), type: "jpeg", user: "DWZEQwcVoPhGb9NMDrPTi5UluUy1")
}
