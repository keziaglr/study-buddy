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
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                Text("Community Members")
                    .fontWeight(.bold)
                    .font(.system(size: 21))
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.1)
                
                Image(systemName: "person.3.fill")
                    .resizable()
                    .foregroundColor(Color(red: 0.259, green: 0.447, blue: 0.635))
                    .frame(width: 200, height: 108)
                    .aspectRatio(contentMode: .fit)
                    .position(x: geometry.size.width / 2 , y : geometry.size.height * 0.25)
                
                membersList
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                    .clipShape(RoundedRectangle(cornerRadius: 15))
                    .padding(.top, geometry.size.height * 0.3)
                    .listStyle(.plain)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.7)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(.bottom, 116)
            .background(Color(red: 0.965, green: 0.965, blue: 0.965))
            .onAppear {
                communityViewModel.getMembers(communityId: communityID)
            }
        }
    }
    
    private var membersList: some View {
        List(communityViewModel.members, id: \.id) { member in
            MembersBubbleComponent(member: member)
        }
    }
}

struct ChatMembersView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMembersView(communityID: .constant("1qVFL6zpyxdDpO5TpSPo"), communityViewModel: CommunityViewModel())
    }
}

