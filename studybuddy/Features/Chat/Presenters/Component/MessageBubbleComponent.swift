//
//  MessageBubbleComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase
import Kingfisher

struct MessageBubbleComponent: View {
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @State private var showTime = false
    @State private var member: CommunityMember?
    
    @State private var vStackHeight: CGFloat = 0
    var isCurrentUser: Bool
    var message: Chat
    var communityID: String
    
    init(message: Chat, communityID: String) {
        self.message = message
        self.isCurrentUser = Auth.auth().currentUser?.uid != message.user
        self.communityID = communityID
    }
    
    
    var body: some View {
        
        
        HStack(alignment: .top) {
            
            if Auth.auth().currentUser?.uid != message.user  {
                if let userImage = member?.image, userImage != "" {
                    KFImage(URL(string: userImage))
                        .placeholder ({ progress in
                            ProgressView()
                        })
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                } else {
                    Images.profilePlaceholder
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(EdgeInsets(top: 5, leading: 0, bottom: 0, trailing: 0))
                }
            }
            
            //User Name
            VStack(alignment: isCurrentUser ? .leading : .trailing, spacing: -1){
                if isCurrentUser {
                    Text(member?.name ?? "")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .kerning(0.45)
//                        .padding(.top, isCurrentUser ? 10 : 5)
                        .padding(EdgeInsets(top: 5, leading: 5, bottom: 5, trailing: 5))
                        .foregroundColor(Colors.black)
                }
                
                //Message Content
                Text(message.content)
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .kerning(0.45)
                    .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 10))
                    .foregroundColor(Colors.black)
                    .frame(alignment: .leading)
                //                    .frame(minWidth: 10, maxWidth: 238, alignment: .leading)
                    .background(Colors.gray)
                    .clipShape(RoundedCorner(radius: 15, corners: isCurrentUser ? [.topRight, .bottomLeft, .bottomRight] : [.topLeft, .topRight, .bottomLeft]))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                    .padding(.top, isCurrentUser ? 0 : 5)
                
                //Time Stamp
                Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 10))
                    .foregroundColor(Colors.black)
            }
        }
        .task {
            do {
                self.member = try await communityViewModel.getCommunityMember(communityID: communityID, userID: message.user)
            } catch {
                print(error)
            }
        }
    }
}




extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape( RoundedCorner(radius: radius, corners: corners) )
    }
}

struct RoundedCorner: Shape {
    
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

#Preview {
    MessageBubbleComponent(message: Chat.previewDummy, communityID: Community.previewDummy.id!)
        .environmentObject(CommunityViewModel())
        .previewLayout(PreviewLayout.sizeThatFits)
}

