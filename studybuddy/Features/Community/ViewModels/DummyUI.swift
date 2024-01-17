//
//  DummyUI.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 26/06/23.
//

import SwiftUI

struct DummyUI: View {
    
    @StateObject var communityViewModel = CommunityViewModel()
    @Binding var communityID : String
    
    var body: some View {
        VStack{
            Text("Test")
            List(communityViewModel.members, id: \.id){ member in
                Text(member.id)
                Text(member.name)

            }
            
            List(communityViewModel.communities, id: \.id){ community in
                Text(community.id!)
                Text(community.description)
                
            }
            
            Image("placeholder")
            
            Text(communityID)
            
            Button{
                communityViewModel.leaveCommunity(communityID: communityID)
            }label: {
                Text("Exit")
            }
        }
//        .onAppear{
//            //                CommunityViewModel.getMembers(communityId: communityID)
//            CommunityViewModel.getMembers(communityId: communityID)
//            CommunityViewModel.userRecommendation()
//            
//        }
    }
    
}

struct DummyUI_Previews: PreviewProvider {
    static var previews: some View {
        DummyUI(communityID: .constant(String("DXZWbcD5WVhfsGNiB6JZ")))
    }
}
