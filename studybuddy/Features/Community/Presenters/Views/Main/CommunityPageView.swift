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
    @State var goToCommunityDetail : Bool = false
    
    @State var showSuccessJoinAlert = false
    @State var showCannotJoinAlert = false
    @State var showBadge = false
    @State var badgeImage = ""
    
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
                    
                    Text("Check another community, based on your interests ")
                        .font(.system(size: 20))
                        .kerning(0.6)
                        .frame(width: 317, alignment: .leading)
                        .position(x: geometry.size.width * 0.5 , y: geometry.size.height * 0.29)
                    
                    ScrollView(.horizontal, showsIndicators: false) {
                        LazyHStack(spacing: 25) {
                            ForEach(communityViewModel.recommendedCommunities) { community in
                                if communityViewModel.validateCommunityJoined(communityID: community.id!) {
                                    CommunityCardComponent(community: community, buttonLabel: "JOIN") {
                                        self.chosenCommunity = community
                                        Task {
                                            do {
                                                communityViewModel.isLoading = true
                                                try await communityViewModel.joinCommunity(community: community)
                                                showSuccessJoinAlert.toggle()
                                            } catch {
                                                print(error)
                                            }
                                            communityViewModel.isLoading = false
                                        }
                                    }
                                } else {
                                    CommunityCardComponent(community: community, buttonLabel: "OPEN") {
                                        self.chosenCommunity = community
                                        goToCommunityDetail = true
                                    }
                                }
                            }
                        }
                        .padding()
                    }
                    .frame(height:145)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.42)
                    
                    Text("Your Community ✨")
                        .font(.system(size: 20))
                        .fontWeight(.bold)
                        .kerning(0.6)
                        .frame(width: 317, alignment: .leading)
                        .position(x: geometry.size.width * 0.5 , y: geometry.size.height * 0.53)
                    
                    if filteredCommunities.isEmpty {
                        Text("Start joining community!")
                            .position(x: geometry.size.width / 2, y: geometry.size.height * 0.6)
                    } else {
                        List(filteredCommunities) { community in
                            CommunityCardComponent(community: community, buttonLabel: "OPEN") {
                                self.chosenCommunity = community
                                goToCommunityDetail = true
                            }
                            .listRowSeparator(.hidden)
                        }
                        .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.35)
                        .position(x: geometry.size.width / 2, y: geometry.size.height * 0.73)
                        .listStyle(.plain)
                        .scrollIndicators(.hidden)
                    }
                    
                    LoaderComponent(isLoading: $communityViewModel.isLoading)
                }
            }
            .ignoresSafeArea()
            .navigationDestination(isPresented: $goToCommunityDetail) {
                ChatRoomView(community: $chosenCommunity)
            }
        }
        .alert(isPresented: $communityViewModel.showErrorAlert, content: {
            communityViewModel.errorAlert
        })
        .alert(isPresented: $showSuccessJoinAlert) {
            Alerts.successJoinCommunity {
                Task {
                    do {
                        showBadge = try await communityViewModel.validateBadgeWhenJoinCommunity(community: chosenCommunity)
                        if !showBadge {
                            goToCommunityDetail = true
                        }
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
    
}

struct CommunityPageView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPageView()
    }
}
