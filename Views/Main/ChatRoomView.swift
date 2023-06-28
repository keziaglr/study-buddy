//
//  ChatRoomView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase


struct ChatRoomView: View {
    @ObservedObject var manager : MessageManager
    @State var communityID : String = "A0grBMs808NJcvvnQjLE"
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0){
                
                Rectangle()
                    .fill(Color(red: 0.439, green: 0.843, blue: 0.984))
                    .frame(height: UIScreen.main.bounds.height * 0.07)
                
                //Info
                ChatRoomInfoComponent()
                
                //Study Schedule
                StudyScheduleComponent()
                
                //Chat Window
                
                ScrollViewReader { proxy in
                    ScrollView(showsIndicators: false){
                        if manager.chats.count != 0 {
                            ForEach(manager.chats, id: \.id) {
                                message in
                                HStack {
                                    if Auth.auth().currentUser?.uid != message.user{
                                        MessageBubbleComponent(message: message)
                                        Spacer()
                                    }else{
                                        Spacer()
                                        MessageBubbleComponent(message: message)
                                    }
                                }
                            }
                        }else{
                            Text("Empty messages")
                        }

                    }.padding()
                    .task {
                        manager.getChats(communityID: communityID)
                    }
                    .onChange(of: manager.lastmessageID) { id in
                        proxy.scrollTo(id, anchor: .bottom)
                    }

                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 10, trailing: 0))
                
                //Message Input Field
                MessageInputComponent(communityID: communityID)
                    .environmentObject(manager)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                
            }
            .ignoresSafeArea(edges: .top)
        }
        
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomView()
//    }
//}