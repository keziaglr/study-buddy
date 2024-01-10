//
//  CommunityCellComponent.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import SwiftUI

struct CommunityCardComponent: View {
    let community: Community
    let buttonLabel: String // New parameter for the button label
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
                actionButton
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
            Text(String(community.category)) // Replace with the actual member count value
                .fontWeight(.medium)
                .font(.system(size: 14))
        }
    }

    private var actionButton: some View {
        HStack {
            Button(action: joinAction) {
                CustomRoundedButton(text: buttonLabel)
            }
        }
    }
}


#Preview {
    CommunityCardComponent(community: Community(id: "", title: "", description: "", image: "", category: ""), buttonLabel: "JOIN", joinAction: {})
}
