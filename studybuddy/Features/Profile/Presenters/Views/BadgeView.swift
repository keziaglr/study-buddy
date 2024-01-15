//
//  BadgeView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import SwiftUI

struct BadgeView: View {
    @EnvironmentObject var userViewModel: UserViewModel
    @ObservedObject var badgeViewModel = BadgeViewModel()
    @State var badges = [Badge]()
    var body: some View {
        VStack {
            Text("Your Badges Collection")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.bottom, 19)
            if !badges.isEmpty {
                List(badges, id: \.id) { (badge: Badge) in
                    BadgeComponent(badge: badge)
                        .environmentObject(userViewModel)
                }
                .listStyle(.plain)
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            } else {
                Text("Empty")
            }
        }
        .task {
            do {
                badges = try await badgeViewModel.getBadges()
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
