//
//  DummyUI.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 26/06/23.
//

import SwiftUI

struct DummyUI: View {
    
    @StateObject var CommunityViewModel : CommunityViewModel
    @Binding var communityID : String
    
    var body: some View {
        VStack{
            Text("Test")
            List(CommunityViewModel.members, id: \.id){ member in
                Text(member.id)
                Text(member.name)

            }
            
            List(CommunityViewModel.communities, id: \.id){ community in
                Text(community.id)
                Text(community.description)
                
            }
            
            Image("placeholder")
            
            Text(communityID)
            
            Button{
                CommunityViewModel.removeMemberFromCommunity(communityID: communityID)
            }label: {
                Text("Exit")
            }
        }.onAppear{
            //                CommunityViewModel.getMembers(communityId: communityID)
            CommunityViewModel.getMembers(communityId: communityID)
            CommunityViewModel.getRecommendation()
            
        }
    }
    
}

struct DummyUI_Previews: PreviewProvider {
    static var previews: some View {
        DummyUI(CommunityViewModel: CommunityViewModel(), communityID: .constant(String("DXZWbcD5WVhfsGNiB6JZ")))
    }
}
