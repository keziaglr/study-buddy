//
//  ChatRoomInfoComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI
import Kingfisher

struct ChatRoomInfoComponent: View {
    
    @Binding var community : Community
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @State private var showStudySchedule = false
    @State var communityMembers = [CommunityMember]()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        
        VStack(spacing: -1){
            
            //Info Bar
            HStack(alignment: .top){
                
                //Back Button
                Button {
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "arrow.backward")
                        .resizable()
                        .foregroundColor(Color.black)
                        .frame(width: 20, height: 18)
                        .padding(EdgeInsets(top: 75, leading: UIScreen.main.bounds.width*0.043257, bottom: 0, trailing: 0))
                    }
                
                //Profile Picture
                KFImage(URL(string: community.image))
                    .placeholder({ progress in
                        ProgressView()
                    })
                    .resizable()
                    .frame(width: 70, height: 70)
                    .scaledToFill()
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                    .padding(EdgeInsets(top: 70, leading: 0, bottom: 0, trailing: 0))
                
                //Title
                VStack(alignment: .leading, spacing: 5){
                    
                    //Group Name
                    Text(community.title)
                        .fontWeight(.bold)
                        .font(.system(size: 18))
                        .foregroundColor(.black)
                    
                    //Number of Members
                    Text("\(communityMembers.count) members")
                        .fontWeight(.regular)
                        .font(.system(size: 15))
                        .foregroundColor(.black)
                    
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
                ChatRoomSettingsComponent(community: $community, communityMembers: $communityMembers)
                    .padding(EdgeInsets(top: 10, leading: 0, bottom: 0, trailing: UIScreen.main.bounds.width*0.043257))
                
            }
            .background(Images.headerGradient)
            .frame(height: 152)
            .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0))
            .ignoresSafeArea()
        }
        .ignoresSafeArea()
        .task {
            do {
                communityMembers = try await communityViewModel.getCommunityMembers(communityID: community.id!)
            } catch {
                print(error)
            }
        }
    }
}

#Preview {
    ChatRoomInfoComponent(community: .constant(Community.previewDummy))
        .environmentObject(CommunityViewModel())
}
