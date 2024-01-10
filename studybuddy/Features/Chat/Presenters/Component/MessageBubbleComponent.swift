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
                AsyncImage(url: URL(string: user?.image ?? "")) { image in
                    image
                        .resizable()
                        .frame(width: 42, height: 42)
                        .clipShape(Circle())
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                        
                } placeholder: {
                    ProgressView()
                }
            } else {
                
            }
            
            //User Name
            
            VStack(alignment: isCurrentUser ? .leading : .trailing, spacing: -1){
                Text(user?.name ?? "")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .padding(EdgeInsets(top: 5, leading: isCurrentUser ? 5 : 30, bottom: 5, trailing: isCurrentUser ? 30 : 5))
                    .foregroundColor(Color(red: 0.306, green: 0.306, blue: 0.306))
                    .background(Color(red: 158/255, green: 215/255, blue: 250/255))
                    .clipShape(RoundedCorner(radius: 15, corners: isCurrentUser ? [.topRight] : [.topLeft]))
                
                //Message Content
                Text(message.content)
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .padding(EdgeInsets(top: 10, leading: 5, bottom: 10, trailing: 5))
                    .foregroundColor(Color(red: 0.306, green: 0.306, blue: 0.306))
                    .frame(minWidth: 100, maxWidth: 238,alignment: .leading)
                    .background(Color(red: 240/255, green: 240/255, blue: 240/255))
                    .clipShape(RoundedCorner(radius: 15, corners: isCurrentUser ? [.topRight, .bottomLeft, .bottomRight] : [.topLeft, .bottomLeft, .bottomRight]))
                
                //Time Stamp
                Text("\(message.dateCreated.formatted(.dateTime.hour().minute()))")
                    .font(.system(size: 14))
                    .fontWeight(.medium)
                    .padding(EdgeInsets(top: 5, leading: 5, bottom: 0, trailing: 10))
                    .foregroundColor(Color(red: 0.306, green: 0.306, blue: 0.306))
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
