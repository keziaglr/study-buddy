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
        ZStack{
            
          
            
            //Title
            Text("Community Members")
                .fontWeight(.bold)
                .font(.system(size: 21))
                .padding(.top)

            //Clock Image
            Image(systemName: "person.3.fill")
                .resizable()
                .foregroundColor(Color(red: 0.259, green: 0.447, blue: 0.635))
                .frame(width: 200,height: 108)
                .aspectRatio(contentMode: .fit)
                .padding(EdgeInsets(top: 46, leading: 0, bottom: 62, trailing: 0))
            //Members List
            List(communityViewModel.members, id: \.id){ member in
                Text(member.id)
                Text(member.name)

            }

            
        }.onAppear{
            communityViewModel.getMembers(communityId: communityID)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 116, trailing: 0))
        .background(Color(red: 0.965, green: 0.965, blue: 0.965))
    }
}

struct ChatMembersView_Previews: PreviewProvider {
    static var previews: some View {
        ChatMembersView(communityID: .constant(String("1qVFL6zpyxdDpO5TpSPo")), communityViewModel: CommunityViewModel())
            
    }
}
