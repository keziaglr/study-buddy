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
    @ObservedObject var bm: BadgeViewModel
    @State private var valid: Bool = false

    var body: some View {
        ZStack {
            HStack {
//                AsyncImage(url: URL(string: badge.image)) { image in
//                    image
//                        .resizable()
//                        .frame(width: 70, height: 70)
//                } placeholder: {
//                    ProgressView()
//                }
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


