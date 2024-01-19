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
    @State var communityMembers: [CommunityMember] = []
    
    var body: some View {
        VStack{
            Text("Test")
            List(communityMembers, id: \.id){ member in
                Text(member.id)
                Text(member.name)

            }
            
            List(communityViewModel.communities, id: \.id){ community in
                Text(community.id!)
                Text(community.description)
                
            }
            
            Image("placeholder")
            
            Text(communityID)
            
//            Button{
//                communityViewModel.leaveCommunity(communityID: communityID)
//            }label: {
//                Text("Exit")
//            }
        }
        .task{
            do {
                communityMembers = try await communityViewModel.getCommunityMembers(communityID: communityID)
            } catch {
                print(error)
            }
        }
    }
    
}

struct DummyUI_Previews: PreviewProvider {
    static var previews: some View {
        DummyUI(communityID: .constant(String("1qVFL6zpyxdDpO5TpSPo")))
    }
}
