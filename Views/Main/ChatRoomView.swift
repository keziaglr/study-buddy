//
//  ChatRoomView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct ChatRoomView: View {
    var body: some View {
        VStack (spacing: 0){
            
            Rectangle()
                .fill(Color(red: 0.439, green: 0.843, blue: 0.984))
                .frame(height: UIScreen.main.bounds.height * 0.07)
            
            //Info
            ChatRoomInfoComponent()
            
            //Study Schedule
            StudyScheduleComponent()
            
            //Chat Window
            ScrollView(showsIndicators: false){
                HStack{
                    MessageBubbleComponent(contentMessage: "Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo Halo ", isCurrentUser: true, userName: "Adriel", messageTime: "09.02 PM")
                        .padding(EdgeInsets(top: 10, leading: 10, bottom: 0, trailing: 0))
                    Spacer()
                }
            }
    
            
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
            
            //Message Input Field
            MessageInputComponent()
                .padding(EdgeInsets(top: 0, leading: UIScreen.main.bounds.width*0.08396947, bottom: 0, trailing: UIScreen.main.bounds.width*0.08396947))
            
            
        }
        .ignoresSafeArea(edges: .top)
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomView()
    }
}
