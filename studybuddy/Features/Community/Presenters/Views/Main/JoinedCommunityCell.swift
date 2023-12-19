//
//  JoinedCommunitycell.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 01/07/23.
//

import SwiftUI

struct JoinedCommunityCell: View {
    let community: Community
    let joinAction: () -> Void
    
    var body: some View {
        ZStack {
            communityImage2
            VStack(alignment: .leading) {
                Spacer()
                communityTitle2
                Spacer()
                memberCount2
                Spacer()
                openButton
                Spacer()
             
            }
            .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.1)
            .padding(.leading, UIScreen.main.bounds.width * 0.052)
            .foregroundColor(.white)
        }
    }
    
    private var communityImage2: some View {
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
    
    private var communityTitle2: some View {
        HStack {
            Text(community.title)
                .fontWeight(.bold)
                .font(.system(size: 19))
                .shadow(radius: 6, x: 2, y: 2)
            Spacer()
        }
    }
    
    private var memberCount2: some View {
        HStack {
            Text(String(community.category)) // Replace with the actual member count value
                .fontWeight(.medium)
                .font(.system(size: 14))
        }
    }
    
    private var openButton: some View {
        HStack {
            Button(action: joinAction) {
                CustomRoundedButton(text: "OPEN")
            }
        }
    }
}
