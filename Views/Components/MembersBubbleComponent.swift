//
//  MembersBubbleComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 26/06/23.
//

import SwiftUI

struct MembersBubbleComponent: View {
    var body: some View {
        ZStack{
            Rectangle()
                .fill(Color.white)
                .frame(width: 302, height: 53)
                .cornerRadius(10, corners: .allCorners)
            
            //Name and Profile Picture
            HStack{
                
                //Profile Picture
                Image("badge1")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 0))
                
                Spacer()
                
                //Name
                Text("Eric Prasetya Sentosa")
                    .fontWeight(.light)
                    .font(.system(size: 18))
                    .foregroundColor(Color.black)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 29))
                
            }
        }
        .frame(width: 302, height: 53)
    }
}

struct MembersBubbleComponent_Previews: PreviewProvider {
    static var previews: some View {
        MembersBubbleComponent()
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
