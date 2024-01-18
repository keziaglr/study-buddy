//
//  ChatMembersView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 26/06/23.
//

import SwiftUI

struct ChatMembersView: View {
    var communityID: String
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @State var communityMembers: [CommunityMember] = []
//    @State private var memberCount: Int = 0
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text("Members")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .foregroundStyle(Colors.orange)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.1)
                
                Image("members")
                    .resizable()
                    .frame(width: 220, height: 220)
                    .aspectRatio(contentMode: .fill)
                    .position(x: geometry.size.width / 2 , y : geometry.size.height * 0.29)
                
//                Text("Total Member : \(communityViewModel.memberCount)")
              
                
                membersList
                    .frame(width: geometry.size.width * 1.1, height: geometry.size.height * 0.6)
                    .listStyle(.plain)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.73)
                    
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 116)
            .task {
                do {
                    communityMembers = try await communityViewModel.getCommunityMembers(communityID: communityID)
                } catch {
                    print(error)
                }
            }
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
        ChatMembersView(communityID: "1qVFL6zpyxdDpO5TpSPo")
            .environmentObject(CommunityViewModel())
    }
}

