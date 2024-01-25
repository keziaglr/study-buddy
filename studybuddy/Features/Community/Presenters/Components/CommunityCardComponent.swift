//
//  CommunityCellComponent.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import SwiftUI
import Kingfisher
struct CommunityCardComponent: View {
    let community: Community
    let buttonLabel: String // New parameter for the button label
    let joinAction: () -> Void
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @State var lastChat: Chat?
    var body: some View {
        ZStack(alignment: .leading) {
            if community.image == "" {
                Images.communityPicture
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .overlay {
                        RoundedRectangle(cornerRadius: 15)
                            .frame(height: UIScreen.main.bounds.height * 0.15)
                            .foregroundStyle(LinearGradient(
                                gradient: Gradient(colors: [Colors.darkBlue, Colors.orange]),
                                startPoint: .leading,
                                endPoint: .trailing
                            ))
                            .opacity(0.6)
                    }
            } else {
                communityImage
            }
            VStack(alignment: .leading, spacing: UIScreen.main.bounds.height * 0.01) {
                Text(community.title)
                    .fontWeight(.bold)
                    .font(.system(size: 19))
                
                Text(String(community.category))
                    .fontWeight(.medium)
                    .font(.system(size: 14))
                actionButton
            }
            .padding(.leading, UIScreen.main.bounds.width * 0.052)
            .foregroundColor(.white)
            
        }
        .frame(height: UIScreen.main.bounds.height * 0.15)
        .task {
            if buttonLabel == "OPEN" {
                do {
                    lastChat = try await communityViewModel.getLastChat(communityID: community.id!)
                } catch {
                    print(error)
                }
            }
        }
    }

    private var communityImage: some View {
        KFImage(URL(string: community.image))
            .placeholder({ progress in
                ProgressView()
            })
            .resizable()
            .aspectRatio(contentMode: .fill)
            .frame(height: UIScreen.main.bounds.height * 0.15)
            .clipShape(RoundedRectangle(cornerRadius: 15))
            .overlay {
                RoundedRectangle(cornerRadius: 15)
                    .frame(height: UIScreen.main.bounds.height * 0.15)
                    .foregroundStyle(LinearGradient(
                        gradient: Gradient(colors: [Colors.darkBlue, Colors.orange]),
                        startPoint: .leading,
                        endPoint: .trailing
                    ))
                    .opacity(0.6)
            }
    }

    private var actionButton: some View {
        HStack() {
            Button(action: joinAction) {
                CustomRoundedButton(text: buttonLabel)
            }
            if let lastChat = lastChat {
                Text("Latest message at \(lastChat.dateCreated.onlyHourMinute())")
                    .font(.system(size: 15))
                    .italic()
                    .foregroundColor(.white)
                    .padding(.leading, 15)
            }
        }
    }
}


#Preview {
    CommunityCardComponent(community: Community.previewDummy, buttonLabel: "JOIN", joinAction: {})
}
