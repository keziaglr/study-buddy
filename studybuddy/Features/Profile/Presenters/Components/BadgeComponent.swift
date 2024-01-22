//
//  BadgeComponent.swift
//  mini2
//
//  Created by Randy Julian on 23/06/23.
//

import SwiftUI
import Combine


struct BadgeComponent: View {
    let badge: Badge
    @StateObject var badgeManager = BadgeManager.shared
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
                valid = badgeManager.validateBadge(badgeName: badge.name)
            }
        }
        
    }
}

#Preview {
    BadgeComponent(badge: Badge.data[0])
}
