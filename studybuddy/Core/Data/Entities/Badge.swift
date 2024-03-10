//
//  Badge.swift
//  studybuddy
//
//  Created by Kezia Gloria on 22/06/23.
//

import Foundation
import FirebaseFirestoreSwift

struct Badge: Identifiable, Codable {
    var id: String
    var name: String
    var image: String
    var description: String
    var rule: String
    
    static let data = [
        Badge(id: "0", name: "Scholar Supreme", image: "Scholar Supreme", description: "You've nailed a week of consistent use on Study Buddy! Keep up the great work! 🚀", rule: "Chat seven days in a row."),
        Badge(id: "1", name: "Collaborative Dynamo", image: "Collaborative Dynamo", description: "Congrats on setting your first study schedule in the community! Keep rocking those study sessions! 🚀📚", rule: "Set Study Schedule for the first time."),
        Badge(id: "2", name: "Knowledge Navigator", image: "Knowledge Navigator", description: "Hooray! You've just scored your first download from the library! Nice work! 🎉", rule: "Download from Library for the first time."),
        Badge(id: "3", name: "Engaged Explorer", image: "Engaged Explorer", description: "You're now part of two different communities with different topics! Keep on exploring! Keep connecting and enjoying the journey! 🚀🤝", rule: "Join 2 Communities with different category."),
        Badge(id: "4", name: "Learning Luminary", image: "Learning Luminary", description: "You're now part of three awesome communities in our collaboration app. Keep the connections rolling! 🌐🎉", rule: "Join 3 Communities."),
        Badge(id: "5", name: "Research Guru", image: "Research Guru", description: "You've uploaded 5 files to the library! Great job, keep it up! 🚀📚", rule: "Upload 5 files to the Library.")
    ]
}

