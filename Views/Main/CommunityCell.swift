//
//  CommunityCell.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 01/07/23.
//

import SwiftUI

struct CommunityCell: View {
    let community: Community
    let joinAction: () -> Void
    
    var body: some View {
        ZStack {
            communityImage
            VStack(alignment: .leading) {
                Spacer()
                communityTitle
                Spacer()
                memberCount
                Spacer()
                joinButton
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.1)
            .padding(.leading, UIScreen.main.bounds.width * 0.052)
            .foregroundColor(.white)
        }
    }
    
    private var communityImage: some View {
        AsyncImage(url: URL(string: community.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.15)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.15)
                        .foregroundColor(Color("DarkBlue"))
                        .opacity(0.42)
                }
        } placeholder: {
            ProgressView()
        }
    }
    
    private var communityTitle: some View {
        HStack {
            Text(community.title)
                .fontWeight(.bold)
                .font(.system(size: 19))
                .shadow(radius: 6, x: 2, y: 2)
            Spacer()
        }
    }
    
    private var memberCount: some View {
        HStack {
            Text("0") // Replace with the actual member count value
                .fontWeight(.medium)
                .font(.system(size: 14))
        }
    }
    
    private var joinButton: some View {
        HStack {
            Button(action: joinAction) {
                CustomRoundedButton(text: "JOIN")
            }
        }
    }
}
