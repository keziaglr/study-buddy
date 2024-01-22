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
    //TODO: change to stateobject
    @StateObject var chatViewModel = ChatViewModel()
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @Binding var community: Community
    
    var body: some View {
        NavigationStack {
            VStack (spacing: 0){
                //Info
                ChatRoomInfoComponent(community: $community)
                
                //Study Schedule
                StudyScheduleComponent(community: $community)
                
                //Chat Window
                ScrollViewReader { proxy in
                    ScrollView(.vertical, showsIndicators: false){
                        if chatViewModel.chats.count != 0 {
                            ForEach(chatViewModel.chats, id: \.id) {
                                message in
                                HStack {
                                    if Auth.auth().currentUser?.uid != message.user{
                                        MessageBubbleComponent(message: message)
                                            .id(message.id)
                                        Spacer()
                                    }else{
                                        Spacer()
                                        MessageBubbleComponent(message: message)
                                            .id(message.id)
                                    }
                                }
                            }
                        }else{
                            Text("Start chatting now!")
                                .padding()
                        }
                    }
                    .padding(.horizontal, 20)
                    .onChange(of: chatViewModel.lastmessageID) { id in
                        proxy.scrollTo(id, anchor: .bottom)
                    }

                }
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
                
                //Message Input Field
                MessageInputComponent(communityID: community.id!)
                    .padding(EdgeInsets(top: 0, leading: 20, bottom: 0, trailing: 20))
                
                
            }
            .ignoresSafeArea(edges: .top)
            .navigationBarBackButtonHidden()
            .onAppear {
                chatViewModel.getChats(communityID: community.id!)
            }
            .sheet(isPresented: $chatViewModel.showAchievedScholarSupremeBadge) {
                // TODO: ganti ya pake yang sesuai badgenya
                BadgeEarnedView(badge: chatViewModel.showedBadge)
            }
        }
        .environmentObject(chatViewModel)
    }
    
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomView()
//    }
//}
