//
//  BadgeView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import SwiftUI

struct BadgeView: View {
    @ObservedObject var bm = BadgeViewModel()
    
    
    var body: some View {
        VStack {
            Text("Your Badges Collection")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.bottom, 10)
            if !bm.badges.isEmpty {
                List(bm.badges, id: \.id) { (badge: Badge) in
                    BadgeComponent(badge: badge, bm: bm)
                }
                .listStyle(.plain)
                .scrollIndicators(.hidden)
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
            }else{
                Text("Empty")
            }
        }
        .padding(.top, -35)
        .task {
            self.bm.getBadges()
        }
    }
}

#Preview {
    BadgeView()
}
