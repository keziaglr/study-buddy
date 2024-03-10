//
//  BadgeView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import SwiftUI

struct BadgeView: View {
    @StateObject var badgeManager = BadgeManager.shared
    
    var body: some View {
        VStack {
            Text("Your Badges Collection")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.bottom, 10)
            if !badgeManager.badges.isEmpty {
                List(badgeManager.badges, id: \.id) { (badge: Badge) in
                    BadgeComponent(badge: badge)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .padding(.horizontal, 32)
            } else {
                Text("Empty")
            }
        }
        .padding(.top, -35)
    }
}

#Preview {
    BadgeView()
}
