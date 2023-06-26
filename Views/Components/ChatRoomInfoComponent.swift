//
//  ChatRoomInfoComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct ChatRoomInfoComponent: View {
    
    var body: some View {
        
        VStack(spacing: -1){
            
            
            //Info Bar
            HStack(alignment: .top){
                
                //Back Button
                Button {
                    print("tap")
                } label: {
                    Image(systemName: "chevron.backward.circle")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 30, height: 30)
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                    }
                
                //Profile Picture
                Image("profile_picture")
                    .resizable()
                    .frame(width: 70, height: 70)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 30, trailing: 10))
                
                //Title
                VStack(alignment: .leading, spacing: 3){
                    
                    //Group Name
                    Text("Mathematics Algebra")
                        .fontWeight(.bold)
                        .font(.system(size: 20))
                        .foregroundColor(.white)
                    
                    //Number of Members
                    Text("2 members")
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                    
                    //Group Description
                    Text("Description")
                        .italic()
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                        .foregroundColor(.white)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                    
                }
                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
                
                //Settings Button
                Menu{
                    Button(action: {
                        // Handle "Set Study Schedule" button tap
                    }) {
                        Label("Set Study Schedule", systemImage: "calendar")
                    }
                    Button(action: {
                        // Handle "Library" button tap
                    }) {
                        Label("Library", systemImage: "book")
                    }
                    Button(action: {
                        // Handle "View Members" button tap
                    }) {
                        Label("View Members", systemImage: "person.2")
                    }
                    Divider()
                    Button(action: {
                        // Handle "Leave Community" button tap
                    }) {
                        Label("Leave Community", systemImage: "xmark.circle")
                    }
                    
                } label: {
                    Image(systemName: "ellipsis.circle")
                        .resizable()
                        .foregroundColor(Color.white)
                        .frame(width: 30, height: 30)
                        .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
                }
            }
            .background(Color(red: 0.439, green: 0.843, blue: 0.984))
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
        }
        .ignoresSafeArea()
        .background(Color(red: 0.906, green: 0.467, blue: 0.157))
    }
}


struct ChatRoomInfoComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomInfoComponent()
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
