//
//  ChatRoomInfoComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct ChatRoomSettingsComponent: View {
    
    @State private var isSetStudySchedulePresented = false
    @State private var isLibraryButtonPresented = false
    @State private var isViewMembersPresented = false
    @State private var isLeaveCommunityPresented = false
    
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
                Button(action: {
                    isLibraryButtonPresented = true
                }) {
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
                    isLeaveCommunityPresented = true
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
                
            }
            
        label: {
            Image(systemName: "ellipsis.circle")
                .resizable()
                .foregroundColor(Color.white)
                .frame(width: 30, height: 30)
//                .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: 10))
        }
        }
        .sheet(isPresented: $isSetStudySchedulePresented) {
            SetScheduleView()
        }
        .sheet(isPresented: $isViewMembersPresented){
            ChatMembersView()
        }
        
    }
}

struct ChatRoomSettingsComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChatRoomSettingsComponent()
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
