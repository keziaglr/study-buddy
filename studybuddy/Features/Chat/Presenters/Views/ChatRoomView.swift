//
//  ChatRoomView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI
import Foundation


struct ChatRoomView: View {
    //TODO: change to stateobject
    @StateObject var chatViewModel = ChatViewModel()
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @Binding var community: Community
    var userManager = UserManager.shared
    var body: some View {
        VStack (spacing: 0){
            //Info
            ChatRoomInfoComponent(community: $community)
            
            //Study Schedule
            StudyScheduleComponent(community: $community)
            
            //Chat Window
            ScrollViewReader { proxy in
                ScrollView(.vertical, showsIndicators: false){
                    if chatViewModel.chats.count != 0 {
                        ForEach(Array(chatViewModel.chats.enumerated()), id: \.1.id) { index, message in
                            VStack {
                                if index > 0 && isDayDifferenceOne(previousDate: chatViewModel.chats[index - 1].dateCreated, messageDate: message.dateCreated) {
                                    //TODO: CHANGE WITH BETTER DIVIDER
                                    Divider()
                                    Text(message.dateCreated.dateFormatWithDay())
                                }
                                HStack {
                                    if userManager.currentUser?.id != message.user{
                                        MessageBubbleComponent(message: message, communityID: community.id!)
                                            .id(message.id)
                                        Spacer()
                                    }else{
                                        Spacer()
                                        MessageBubbleComponent(message: message, communityID: community.id!)
                                            .id(message.id)
                                    }
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
            BadgeEarnedView(badge: chatViewModel.showedBadge)
        }
        .onTapGesture {
            hideKeyboard()
        }
        .environmentObject(chatViewModel)
    }
    func isDayDifferenceOne(previousDate: Date, messageDate: Date) -> Bool {
        let calendar = Calendar.current
        let startOfDayStartDate = calendar.startOfDay(for: previousDate)
        let startOfDayEndDate = calendar.startOfDay(for: messageDate)
        
        let components = calendar.dateComponents([.day], from: startOfDayStartDate, to: startOfDayEndDate)
        return components.day! >= 1
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomView()
//    }
//}
