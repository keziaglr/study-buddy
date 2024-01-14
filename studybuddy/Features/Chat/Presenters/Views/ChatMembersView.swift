//
//  ChatMembersView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 26/06/23.
//

import SwiftUI

struct ChatMembersView: View {
    @Binding var communityID: String
    @StateObject var communityViewModel: CommunityViewModel
//    @State private var memberCount: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text("Members")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .foregroundStyle(Color("Orange"))
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.1)
                
                Image("members")
                    .resizable()
                    .frame(width: 220, height: 220)
                    .aspectRatio(contentMode: .fill)
                    .position(x: geometry.size.width / 2 , y : geometry.size.height * 0.29)
                
//                Text("Total Member : \(communityViewModel.memberCount)")
              
                
                membersList
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                    .listStyle(.plain)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.73)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 116)
            .onAppear {
                communityViewModel.getMembers(communityId: communityID)
            }
        }
    }
    
    private var membersList: some View {
        List(communityViewModel.members, id: \.id) { member in
            MembersBubbleComponent(member: member)
                .listRowSeparator(.hidden)
                .listStyle(.plain)
                .frame(alignment: .leading)
            
        }
    }
}

struct ChatMembersView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMembersView(communityID: .constant("1qVFL6zpyxdDpO5TpSPo"), communityViewModel: CommunityViewModel())
    }
}

