//
//  BadgeComponent.swift
//  mini2
//
//  Created by Randy Julian on 23/06/23.
//

import SwiftUI
import Combine


struct BadgeView: View {
    let badge: Badge
    @ObservedObject var bm: BadgeViewModel
    @State private var valid: Bool = false

    var body: some View {
        ZStack {
            HStack {
                Image(badge.name)
                    .resizable()
                    .frame(width: 70, height: 70)
                Text("\(badge.name)")
                    .padding(.leading, 20)
                    .fontWeight(.bold)
                    .font(.system(size: 15))
                
            }
            .opacity(valid ? 1.0 : 0.2)
            .onAppear {
                bm.validateBadge(badgeId: badge.id) { isValid in
                    valid = isValid
                }
            }
        }
        
    }
}


struct BadgeComponent: View {
    @ObservedObject var bm = BadgeViewModel()
    
    
    var body: some View {
        VStack {
            Text("Your Badges Collection")
                .fontWeight(.bold)
                .font(.system(size: 25))
                .kerning(0.75)
                .padding(.bottom, 19)
            if !bm.badges.isEmpty {
                List(bm.badges, id: \.id) { (badge: Badge) in
                    BadgeView(badge: badge, bm: bm)
                }
                .listRowSeparator(.hidden)
                .listStyle(.inset)
                .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
                }else{
                    Text("Empty")
                }
        }
        .task {
            self.bm.getBadges()
        }
        .padding(.top, 250)

    }
}

struct BadgeComponent_Previews: PreviewProvider {
    static var previews: some View {
        BadgeComponent()
    }
}
