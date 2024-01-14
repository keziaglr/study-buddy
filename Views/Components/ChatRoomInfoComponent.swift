//
//  ChatRoomInfoComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct ChatRoomInfoComponent: View {
    
    @State private var showStudySchedule = false
    @Binding var showTabView : Bool
    @Binding var community : Community
    @Binding var communityId : String
    @State private var cvm = CommunityViewModel()
    var body: some View {
        
        VStack(spacing: -1){
            
            //Info Bar
            HStack(alignment: .top){
                
                //Back Button
                Button {
                    showTabView = false
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 20, height: 18)
                        .padding(EdgeInsets(top: 75, leading: UIScreen.main.bounds.width*0.043257, bottom: 0, trailing: 0))
                    }
                
                //Profile Picture
                AsyncImage(url: URL(string: community.image)) { image in
                    image
                        .resizable()
                        .frame(width: 70, height: 70)
                        .scaledToFill()
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                        
                } placeholder: {
                    ProgressView()
                }
                
                //Title
                VStack(alignment: .leading, spacing: 5){
                    
                    //Group Name
                    Text(community.title)
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    //Number of Members
                    Text("\(cvm.memberCount) members")
                        .fontWeight(.regular)
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .onAppear{
                            cvm.getMembers(communityId: community.id)
                        }
                    
                    //Group Description
                    Text(community.description)
                        .italic()
                        .fontWeight(.regular)
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                        .padding(EdgeInsets(top: 0, leading: 0, bottom: 30, trailing: 0))
                    
                }
                .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
                
                //Settings Button
                ChatRoomSettingsComponent(communityViewModel: CommunityViewModel(), communityId: $communityId, community: $community)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: UIScreen.main.bounds.width*0.043257))
                
            }
            .background(Image("header_gradient"))
            .frame(height: 152)
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
//        .background(Color(red: 0.906, green: 0.467, blue: 0.157))
    }
}

//struct ChatRoomInfoComponent_Previews: PreviewProvider {
//    static var previews: some View {
//        ChatRoomInfoComponent()
//            .previewLayout(PreviewLayout.sizeThatFits)
//    }
//}
