//
//  MembersBubbleComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 26/06/23.
//

import SwiftUI
import Kingfisher

struct MembersBubbleComponent: View {
    let member : CommunityMember
    
    var body: some View {
        
        //Name and Profile Picture
        HStack{
            
            //Profile Picture
            VStack(alignment: .leading){
                if member.image == "" {
                    Images.profilePlaceholder
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                        .padding(.horizontal, 30)
                } else {
                    KFImage(URL(string: member.image))
                        .placeholder ({ progress in
                            ProgressView()
                        })
                        .resizable()
                        .scaledToFill()
                        .frame(width: 50, height: 50)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                        .padding(.horizontal, 30)
                }
            }
            .frame(width: 50)
            
            VStack(alignment: .leading){
                //Name
                Text(member.name)
                    .fontWeight(.regular)
                    .font(.system(size: 18))
                    .foregroundColor(Colors.black)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                    .padding(.leading, 30)
            }
            Spacer()
        }
    }
}

struct MembersBubbleComponent_Previews: PreviewProvider {
    static var previews: some View {
        MembersBubbleComponent(member: CommunityMember(id: "Test", name: "Test", image: "gs://mc2-studybuddy.appspot.com/communities/ab6761610000e5eb006ff3c0136a71bfb9928d34.jpeg"))
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
