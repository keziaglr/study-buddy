//
//  ChatMembersView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 26/06/23.
//

import SwiftUI

struct ChatMembersView: View {
    
    @Binding var communityID : String
    
    @StateObject var communityViewModel : CommunityViewModel
    
    var body: some View {
        GeometryReader { geometry in
            VStack{
                //Title
                Text("Community Members")
                    .fontWeight(.bold)
                    .font(.system(size: 21))
                    .padding(EdgeInsets(top: geometry.size.height*0.07702182, leading: 0, bottom: 0, trailing: 0))
                
                //Clock Image
                Image(systemName: "person.3.fill")
                    .resizable()
                    .foregroundColor(Color(red: 0.259, green: 0.447, blue: 0.635))
                    .frame(width: geometry.size.width*0.48730964,height: geometry.size.height*0.13863928)
                    .padding(EdgeInsets(top: geometry.size.width*0.05905006, leading: 0, bottom: geometry.size.height*0.07958922, trailing: 0))
                
                
                
                //Members List
                List(communityViewModel.members, id: \.id){ member in
                    MembersBubbleComponent(member: member)
                }
                
            }.onAppear{
                communityViewModel.getMembers(communityId: communityID)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 116, trailing: 0))
        .background(Color(red: 0.965, green: 0.965, blue: 0.965))
        }
    }
}

struct ChatMembersView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMembersView(communityID: .constant(String("1qVFL6zpyxdDpO5TpSPo")), communityViewModel: CommunityViewModel())
            
    }
}
