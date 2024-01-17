//
//  CommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct CommunityPageView: View {
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @State private var searchText = ""
    @State var chosenCommunity: Community = Community(title: "", description: "", image: "", category: "")
    @State var showCommunityDetail : Bool = false
    
    var filteredCommunities: [Community] {
        if searchText.isEmpty {
            return communityViewModel.joinedCommunities
        } else {
            return communityViewModel.joinedCommunities.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                GeometryReader { geometry in
                    
                    HeaderComponent(text: "Your Learning Squad! 👥")
                    
                    SearchBarComponent(searchText: $searchText)
                        .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.21)
                    
                    Text("Here’s some recommendation for you")
                        .font(.system(size: 20))
                        .kerning(0.6)
                        .frame(width: 317, alignment: .leading)
                        .position(x: geometry.size.width * 0.5 , y: geometry.size.height * 0.29)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 25) {
                            ForEach(communityViewModel.recommendedCommunities) { community in
                                CommunityCardComponent(community: community, buttonLabel: "JOIN") {
                                    Task {
                                        do {
                                            try await communityViewModel.joinCommunity(communityID: community.id!)
                                        } catch {
                                            print(error)
                                        }
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height:145)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.42)
                    
                    Text("Joined Community")
                        .font(.system(size: 20))
                        .kerning(0.6)
                        .frame(width: 317, alignment: .leading)
                        .position(x: geometry.size.width * 0.5 , y: geometry.size.height * 0.55)
                    
                    if filteredCommunities.isEmpty {
                        Text("Start joining community!")
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                    } else {
                        List(filteredCommunities) { community in
                            CommunityCardComponent(community: community, buttonLabel: "OPEN") {
                                self.chosenCommunity = community
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
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $showCommunityDetail) {
                ChatRoomView(community: $chosenCommunity)
//                    .environmentObject(communityViewModel)
            }
        }
    }
}

struct CommunityPageView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPageView()
    }
}
