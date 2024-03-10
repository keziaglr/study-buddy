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
        HStack(spacing: 20) {
            Image(badge.name)
                .resizable()
                .frame(width: 70, height: 70)
            VStack(alignment: .leading) {
                Text(badge.name)
                    .fontWeight(.bold)
                    .font(.system(size: 15))
                    .padding(.bottom, 1)
                Text(badge.rule)
                    .font(.system(size: 15))
                    .opacity(0.5)
            }
        }
        .opacity(valid ? 1.0 : 0.2)
        .onAppear {
            valid = badgeManager.validateBadge(badgeName: badge.name)
        }
        
    }
}

#Preview {
    BadgeComponent(badge: Badge.data[1])
}
