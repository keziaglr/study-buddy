//
//  ChatRoomInfoComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct ChatRoomSettingsComponent: View {
    
    @EnvironmentObject var communityViewModel : CommunityViewModel
    
    @Binding var community: Community
    @Binding var communityMembers: [CommunityMember]
    
    @State var isSetStudySchedulePresented = false
    @State var isLibraryButtonPresented = false
    @State var isViewMembersPresented = false
    @State var isLeaveCommunityPressed = false
    
    @State var showBadge = false
    
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
//        NavigationStack{
            VStack {
                Menu {
                    //Set Study Schedule Button
                    Button(action: {
                        isSetStudySchedulePresented = true
                    }) {
                        Label(
                            title: {
                                Text("Set Study Schedule")
                            },
                            icon: {
                                Image(systemName: "calendar")
                            }
                        )
                    }
                    
                    //Library Button
                    NavigationLink {
                        LibraryView(communityID: community.id!)
                    } label: {
                        Label(
                            title: {
                                Text("Library")
                            },
                            icon: {
                                Image(systemName: "book")
                            }
                        )
                        
                    }
                    
                    //View Members Button
                    Button(action: {
                        isViewMembersPresented = true
                    }) {
                        Label(
                            title: {
                                Text("View Members")
                            },
                            icon: {
                                Image(systemName: "person.2")
                            }
                        )
                    }
                    
                    
                    //Divider
                    Divider()
                    
                    //Leave Community
                    Button(action: {
                        isLeaveCommunityPressed = true
                    }) {
                        Label(
                            title: {
                                Text("Leave Community")
                            },
                            icon: {
                                Image(systemName: "xmark.circle")
                            }
                        )
                    }
                    
                } label: {
                    Image(systemName: "ellipsis")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 20, height: 4)
                        .padding(EdgeInsets(top: 17, leading: 0, bottom: 0, trailing: 10))
                }
            }
            .sheet(isPresented: $isSetStudySchedulePresented) {
                SetScheduleView(isPresent: $isSetStudySchedulePresented, showBadge: $showBadge, community: $community)
            }
            .sheet(isPresented: $isViewMembersPresented){
                ChatMembersView(communityMembers: $communityMembers)
            }
            .sheet(isPresented: $showBadge) {
                BadgeEarnedView(badge: communityViewModel.showedBadge)
            }
            .alert(isPresented: $isLeaveCommunityPressed) {
                Alerts.successLeaveCommunity(action: {
                    Task{
                        do {
                            communityViewModel.isLoading = true
                            try await communityViewModel.leaveCommunity(communityID: community.id!, communityMembers: communityMembers)
                        } catch {
                            print(error)
                        }
                        communityViewModel.isLoading = false
                        presentationMode.wrappedValue.dismiss()
                    }
                })
            }
//        }
    }
}

//struct ChatRoomSettingsComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomSettingsComponent(communityId: <#Binding<String>#>, community: .constant(Community(id: "SQdVEsc9RiT1Us2cDlEs", title: "Adriel", description: "test", image: "https://firebasestorage.googleapis.com/v0/b/mc2-studybuddy.appspot.com/o/badges%2FKnowledge%20Navigator.png?alt=media&token=6a54846d-cc27-469a-9c7e-67a55b8c28ae", category: "Math")))
//            .previewLayout(PreviewLayout.sizeThatFits)
//    }
//}
