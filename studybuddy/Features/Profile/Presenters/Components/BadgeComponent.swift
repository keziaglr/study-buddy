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
    @EnvironmentObject var viewModel: UserViewModel
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
            .opacity(viewModel.validateBadge(badgeId: badge.id!) ? 1.0 : 0.2)
        }
        
    }
}

