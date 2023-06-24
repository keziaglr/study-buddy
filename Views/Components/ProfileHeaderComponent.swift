//
//  ProfilePageView.swift
//  mini2
//
//  Created by Randy Julian on 23/06/23.
//

import SwiftUI

struct ProfileHeaderComponent: View {
    var body: some View {
        VStack {
            ZStack {
                Image("profile_gradient")
                    .resizable()
                    .scaledToFit()
                    .ignoresSafeArea()
                
                VStack {
                    HStack{
                        Button(action: {
                            //add action
                        }) {
                            Image(systemName: "chevron.backward.circle")
                                .font(.system(size: 24))
                                .padding(EdgeInsets(top: -20, leading: 17, bottom: 0, trailing: 0))
                                .foregroundColor(.white)
                            Spacer()
                        }
                    }
                    
                    //profile image
                    Image("community_picture")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 85, height: 85)
                        .cornerRadius(15)
                        .padding(.bottom, 14)
                    
                    //name
                    Text("Adriel Bernard Rusli")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                        .padding(.bottom, 14)
                    
                    //year joined
                    Text("Member since 2023")
                        .fontWeight(.light)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(.bottom, 14)
                    VStack{
                        Button(action: {
                            //add action
                        }) {
                            Text("Logout")
                                .padding(.horizontal, 16)
                                .padding(.vertical, 8)
                                .font(.system(size: 19))
                                .fontWeight(.bold)
                                .foregroundColor(.white)
                                .background(Color("Orange"))
                                .cornerRadius(10)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            Spacer()
        }
    }
}


struct ProfileHeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderComponent()
    }
}
