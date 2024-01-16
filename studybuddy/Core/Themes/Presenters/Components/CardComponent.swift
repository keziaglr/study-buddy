//
//  CardView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct CardComponent: View {
    
    @Binding var CommunityPicture : String
    @Binding var CommunityName : String
    @Binding var CommunityMemberCount : Int
    
    
    var body: some View {
        
        ZStack{
            //community picture
            Image(CommunityPicture)
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: 302, height: 145)
                .clipped()
                .cornerRadius(15)
                .overlay(
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color("DarkBlue"))
                        .opacity(0.42)
                )
            
            
            VStack {
                //nama community
                HStack {
                    Text(CommunityName)
                        .fontWeight(.bold)
                        .font(.system(size: 19))
                        .foregroundColor(.white)
                        .shadow(radius: 6, x: 2, y: 2)
                        .padding(.top, 10)
                        .padding(.bottom, 1)
                        .padding(.leading, 23)
                    Spacer()
                }
                .frame(width: 302)
                
                //jumlah member
                HStack {
                    Text(String(CommunityMemberCount))
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                        .foregroundColor(Color("Gray"))
                        .padding(.leading, 23)
                    Spacer()
                }
                .frame(width: 302)
                .padding(.bottom, 10)
                
                //button join
                HStack {
                    Button(action: {
                        //add action
                    }) {
                        CustomRoundedButton(text: "JOIN")
                            .padding(.leading, 23)
                    }
                    Spacer()
                }
                .frame(width: 302)
            }
        }
        Spacer()
    }
}

struct CardComponent_Previews: PreviewProvider {
    static var previews: some View {
        CardComponent(CommunityPicture: .constant("community_picture"), CommunityName: .constant("Test"), CommunityMemberCount: .constant(3))
    }
}
