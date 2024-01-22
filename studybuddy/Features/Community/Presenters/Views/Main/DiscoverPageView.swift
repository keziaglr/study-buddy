//
//  DiscoverPageView.swift
//  mini2
//
//  Created by Randy Julian on 24/06/23.
//
//

import SwiftUI
import LottieUI

struct DiscoverPageView: View {
    
    @EnvironmentObject var communityViewModel: CommunityViewModel
    @State private var text = ""
    @State private var showModal = false
    @State var chosenCommunity: Community = Community(title: "", description: "", image: "", category: "")
    @State var goToCommunityDetail : Bool = false
    
    @State var showAlert = false
    @State var showBadge = false
    @State var badgeImage = ""
    @State var showedAlert = Alerts.memberIsFull
    
    var filteredCommunities: [Community] {
        if text.isEmpty {
            return communityViewModel.communities
        } else {
            return communityViewModel.communities.filter {
                $0.category.localizedCaseInsensitiveContains(text) ||
                $0.title.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                HeaderComponent(text: "Explore the Network 🌐")
                
                SearchBarComponent(searchText: $text)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.21)
                
                
                if !filteredCommunities.isEmpty {
                    List(filteredCommunities) { community in
                        if communityViewModel.validateCommunityJoined(communityID: community.id!) {
                            CommunityCardComponent(community: community, buttonLabel: "JOIN") {
                                self.chosenCommunity = community
                                Task {
                                    do {
                                        communityViewModel.isLoading = true
                                        try await communityViewModel.joinCommunity(community: community)
                                        showedAlert = Alerts.successJoinCommunity {
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
                                        showAlert.toggle()
                                    } catch CommunityError.alreadyJoined {
                                        showedAlert = Alerts.alreadyJoined
                                        showAlert.toggle()
                                    } catch CommunityError.memberIsFull {
                                        showedAlert = Alerts.memberIsFull
                                        showAlert.toggle()
                                    } catch {
                                        print(error)
                                    }
                                    communityViewModel.isLoading = false
                                }
                            }
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                print("tapped")
                                hideKeyboard()
                            }
                        } else {
                            CommunityCardComponent(community: community, buttonLabel: "OPEN") {
                                self.chosenCommunity = community
                                goToCommunityDetail = true
                            }
                            .listRowSeparator(.hidden)
                            .onTapGesture {
                                print("tapped")
                                hideKeyboard()
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.65)
                    .listStyle(.plain)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height / 1.75)
                    .scrollIndicators(.hidden)
                    
                } else {
                    VStack {
                        LottieView("notfound")
                            .loopMode(.repeat(10))
                            .frame(width: 200, height: 200)
                        Text("No result found!\nYou can create your community")
                            .multilineTextAlignment(.center)
                            .font(.system(size: 20))
                            .fontWeight(.semibold)
                        CreateCommunityButtonComponent  (showModal: $showModal)
                    }
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.55)
                    .onTapGesture {
                        print("tapped")
                        hideKeyboard()
                    }
                }
                
                LoaderComponent(isLoading: $communityViewModel.isLoading)
            }
            .sheet(isPresented: $showModal) {
                CreateCommunityPageView(showModal: $showModal)
            }
            .sheet(isPresented: $showBadge) {
                BadgeEarnedView(badge: communityViewModel.showedBadge)
            }
            .navigationDestination(isPresented: $goToCommunityDetail) {
                ChatRoomView(community: $chosenCommunity)
            }
        }
        .ignoresSafeArea()
        .alert(isPresented: $showAlert) {
            showedAlert
        }
    }
    
}

struct DiscoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPageView()
            .environmentObject(CommunityViewModel())
    }
}
