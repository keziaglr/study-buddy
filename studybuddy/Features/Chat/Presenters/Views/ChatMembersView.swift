//
//  ChatMembersView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 26/06/23.
//

import SwiftUI

struct ChatMembersView: View {
    @Binding var communityMembers: [CommunityMember]
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text("Members")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .foregroundStyle(Colors.orange)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.1)
                
                Images.members
                    .resizable()
                    .frame(width: 220, height: 220)
                    .aspectRatio(contentMode: .fill)
                    .position(x: geometry.size.width / 2 , y : geometry.size.height * 0.29)
                
                
                membersList
                    .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 0.6)
                    .listStyle(.plain)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.73)
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 116)
        }
    }
    
    private var membersList: some View {
        List(communityMembers, id: \.id) { member in
            MembersBubbleComponent(member: member)
                .listRowSeparator(.hidden)
                .listStyle(.plain)
                .frame(alignment: .leading)
                .padding(.leading, 15)
        }
    }
}

struct ChatMembersView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMembersView(communityMembers: .constant([CommunityMember.previewDummy]))
            .environmentObject(CommunityViewModel())
    }
}

