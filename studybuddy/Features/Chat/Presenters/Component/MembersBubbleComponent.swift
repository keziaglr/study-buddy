//
//  MembersBubbleComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 26/06/23.
//

import SwiftUI

struct MembersBubbleComponent: View {
    let member : communityMember
    
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(width: 302, height: 53)
                .cornerRadius(10, corners: .allCorners)
            
            //Name and Profile Picture
            HStack{
                
                //Profile Picture
                VStack(alignment: .leading){
                    AsyncImage(url: URL(string: member.image)) { image in
                        image
                        
                            .resizable()
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                            .frame(width: 50, height: 50)
                            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                            .padding(.horizontal, 30)
                        
                    } placeholder: {
                        ProgressView()
                    }
                }
                .frame(width: 50)
                
//                Spacer()
                
                VStack(alignment: .leading){
                    //Name
                    Text(member.name)
                        .fontWeight(.regular)
                        .font(.system(size: 18))
                        .foregroundColor(Color.black)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                        .padding(.leading, 30)
                }
                Spacer()
//                .frame(width: 200)
            }
        }
        .frame(width: 280, height: 53)
    }
}

struct MembersBubbleComponent_Previews: PreviewProvider {
    static var previews: some View {
        MembersBubbleComponent(member: communityMember(id: "Test", name: "Test", image: "gs://mc2-studybuddy.appspot.com/communities/ab6761610000e5eb006ff3c0136a71bfb9928d34.jpeg"))
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
