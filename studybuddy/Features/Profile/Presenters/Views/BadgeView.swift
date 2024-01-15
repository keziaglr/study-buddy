//
//  BadgeView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import SwiftUI

struct BadgeView: View {
    @StateObject var badgeViewModel = BadgeViewModel()
    @EnvironmentObject var userViewModel: UserViewModel
    var body: some View {
        VStack {
            Text("Your Badges Collection")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.bottom, 19)
            if !badgeViewModel.badges.isEmpty {
                List(badgeViewModel.badges, id: \.id) { (badge: Badge) in
                    BadgeComponent(badge: badge, currentUser: userViewModel.currentUser)
                        .environmentObject(badgeViewModel)
                }
                .listStyle(.plain)
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            } else {
                Text("Empty")
            }
        }
        .task {
            do {
                try await badgeViewModel.getBadges()
            } catch {
                print(error)
            }
        }
        .padding(.top, 300)
    }
}

#Preview {
    BadgeView()
        .environmentObject(UserViewModel())
}
