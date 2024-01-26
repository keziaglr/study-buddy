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
                    .foregroundColor(Colors.black)
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
                leaveCommunity()
            })
        }
    }
    
    func leaveCommunity() {
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
    }
}
