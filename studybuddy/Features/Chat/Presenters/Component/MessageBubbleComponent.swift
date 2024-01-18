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
    
    var isCurrentUser: Bool
    var message: Chat
    @State private var um = UserViewModel()
    @State private var showTime = false
    @State private var user: UserModel? = nil
    
    @State private var vStackHeight: CGFloat = 0
    
    init(message: Chat) {
        
        self.message = message
        self.isCurrentUser = Auth.auth().currentUser?.uid != message.user
    }
    
    
    var body: some View {
        
        
        HStack(alignment: .top) {
            
            if Auth.auth().currentUser?.uid != message.user  {
//                AsyncImage(url: URL(string: user?.image ?? "")) { image in
//                    image
//                        .resizable()
//                        .scaledToFill()
//                        .frame(width: 42, height: 42)
//                        .clipShape(RoundedRectangle(cornerRadius: 10))
//                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
//                        
//                } placeholder: {
//                    ProgressView()
//                }
                if let userImage = user?.image {
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
                    Image("profile_placeholder")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 42, height: 42)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                }
            } else {
                
            }
            
            //User Name
            VStack(alignment: isCurrentUser ? .leading : .trailing, spacing: -1){
                if isCurrentUser {
                    Text(user?.name ?? "")
                        .font(.system(size: 15))
                        .fontWeight(.semibold)
                        .kerning(0.45)
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
                    .background(Color("Gray"))
                    .clipShape(RoundedCorner(radius: 15, corners: isCurrentUser ? [.topRight, .bottomLeft, .bottomRight] : [.topLeft, .topRight, .bottomLeft]))
                    .padding(.leading, 10)
                    .padding(.trailing, 10)
                
                //Time Stamp
                Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                    .font(.system(size: 15))
                    .fontWeight(.regular)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 10))
                    .foregroundColor(Colors.black)
            }
        }.task {
            um.getUser(id: message.user) { retrievedUser in
                self.user = retrievedUser
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

//struct MessageBubbleComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        MessageBubbleComponent(message: "")
//            .previewLayout(PreviewLayout.sizeThatFits)
//    }
//}
