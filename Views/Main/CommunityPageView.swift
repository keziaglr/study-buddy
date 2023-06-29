//
//  CommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct CommunityPageView: View {
    
    @StateObject var communityViewModel: CommunityViewModel
    @State private var text = ""
    @Binding var community : Community
    @Binding var showCommunityDetail : Bool
    
    var filteredCommunities: [Community] {
        if text.isEmpty {
            return communityViewModel.communities
        } else {
            return communityViewModel.communities.filter {
                $0.title.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    var body: some View {
        
        
        ZStack {
            GeometryReader { geometry in
                
                HeaderComponent(text: "Your Learning Squad!")
                NavigationLink {
                    DummyUI(CommunityViewModel: CommunityViewModel(), communityID: .constant("1qVFL6zpyxdDpO5TpSPo"))
                } label: {
                    Text("next")
                }.position(x: geometry.size.width/2 , y: geometry.size.height * 0.1)
                
                
                
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: geometry.size.width * 0.92, height: 51)
                        .foregroundColor(Color("Orange"))
                    
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: geometry.size.width * 0.9 , height: 45)
                        .foregroundColor(Color("Gray"))
                    
                    HStack {
                        Spacer()
                        TextField("Search Your Community Here", text: $text)
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                .position(x: geometry.size.width/2 , y: geometry.size.height * 0.22)
                
                Text("Recommended Community : ")
                    .font(.system(size: 20))
                    .position(x: geometry.size.width * 0.425 , y: geometry.size.height * 0.28)
                
                List(communityViewModel.rcommunities) { community in
                    Text(community.id)
                    
                }.frame(width: geometry.size.width * 0.9 , height:  geometry.size.height * 0.2)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.42)
                    .listStyle(.plain)
                
                Text("Joined Community : ")
                    .font(.system(size: 20))
                    .position(x: geometry.size.width * 0.35 , y: geometry.size.height * 0.55)
                
                List(filteredCommunities) { community in
                    CommunityCell(community: community){
                        self.community = community
                        showCommunityDetail = true
                    }
                    
                }.frame(width: geometry.size.width * 0.9 , height:  geometry.size.height * 0.35)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.75)
                    .listStyle(.plain)
                
                
                
                
                
            }
            
        }.ignoresSafeArea()
            .onAppear {
                communityViewModel.getRecommendation()
                communityViewModel.getJoinedCommunity()
                //                communityViewModel.getCommunity()
            }
    }
}

//struct CommunityPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityPageView(communityViewModel: CommunityViewModel(), showCommunityDetail: .constant(false))
//
//    }
//}
