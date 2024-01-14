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
            return communityViewModel.jCommunities
        } else {
            return communityViewModel.jCommunities.filter {
                $0.title.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                
                HeaderComponent(text: "Your Learning Squad! 👥")
                
                SearchBar(text: $text)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.21)
                
                Text("Here’s some recommendation for you")
                    .font(.system(size: 20))
                    .kerning(0.6)
                    .frame(width: 317, alignment: .leading)
                    .position(x: geometry.size.width * 0.5 , y: geometry.size.height * 0.29)
                
                ScrollView(.horizontal, showsIndicators: false){
                    HStack(alignment: .center, spacing: 25) {
                        ForEach(communityViewModel.rcommunities) { community in CommunityCell(community: community) {
                            communityViewModel.joinCommunity(communityID: community.id)
                        }
//                        .listRowSeparator(.hidden)
//                        .frame(width: geometry.size.width , height: geometry.size.height * 0.2)
//                        .background(Color.white) // Adjust background color as needed
//                        .cornerRadius(10)
                        }
                        .modifier(ScrollingHStackModifier(items: communityViewModel.rcommunities.count, itemWidth: 302, itemSpacing: 25))
                    }
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.42)
                }
//                List(communityViewModel.rcommunities) { community in
//                    CommunityCell(community: community) {
//                        communityViewModel.joinCommunity(communityID: community.id)
//                    }.listRowSeparator(.hidden)
//                    
//                }.frame(width: geometry.size.width * 0.9 , height:  geometry.size.height * 0.2)
//                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.42)
//                    .listStyle(.plain)
//                    .scrollIndicators(.hidden)
                
                Text("Joined Community")
                    .font(.system(size: 20))
                    .kerning(0.6)
                    .frame(width: 317, alignment: .leading)
                    .position(x: geometry.size.width * 0.5 , y: geometry.size.height * 0.55)
                
                if filteredCommunities.isEmpty {

                    Image("placeholder")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: geometry.size.width * 0.5)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.72)
                    Text("You haven't joined any communities yet.")
                        .frame(maxWidth: 300)
                        .multilineTextAlignment(.center)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.88)

                } else {
                    List(filteredCommunities) { community in
                        JoinedCommunityCell(community: community) {
                            self.community = community
                            showCommunityDetail = true
                        }
                        .listRowSeparator(.hidden)
                    }
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.35)
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.75)
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                }
            }
        }.ignoresSafeArea()
            .onAppear {
                communityViewModel.userRecommendation()
                communityViewModel.getJoinedCommunity()
            }
    }
}

struct CommunityPageView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPageView(communityViewModel: CommunityViewModel(), community: .constant(Community(id: "1", title: "title", description: "description", image: "1", category: "Mathematics")), showCommunityDetail: .constant(false))
    }
}
