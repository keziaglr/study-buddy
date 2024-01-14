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

    @ObservedObject var communityViewModel: CommunityViewModel
    @State var bvm = BadgeViewModel()
    @State private var text = ""
    @State private var showModal = false
    @State private var communityID = ""
    @State private var badge = Badge(id: "", name: "", image: "", description: "")

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
        ZStack{
            GeometryReader { geometry in
                HeaderComponent(text: "Explore the Network 🌐")
                
                SearchBarComponent(text: $text)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.21)
              

                if !filteredCommunities.isEmpty {
                    List(filteredCommunities) { community in
                        CommunityCardComponent(community: community, buttonLabel: "Test") {
                            communityViewModel.joinCommunity(communityID: community.id)
                            communityID = community.id
                        }.listRowSeparator(.hidden)
                    }.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                        .listStyle(.plain)
                        .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.55)
                        .scrollIndicators(.hidden)

                }else {
                    LottieView("notfound")
                        .loopMode(.repeat(10))
                        .frame(width: 200)
                        .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.45)
                    Text("No result found!\nYou can create your community")
                        .multilineTextAlignment(.center)
                        .font(.system(size: 20))
                        .fontWeight(.semibold)
                        .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.62)
                    CreateCommunityButtonComponent  (showModal: $showModal)
                   .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.7)
                }


            }.onAppear {
                communityViewModel.getCommunities()
            }
            .sheet(isPresented: $showModal) {
                CreateCommunityPageView(communityViewModel: CommunityViewModel())
            }
            .sheet(isPresented: $communityViewModel.showBadge) {
                BadgeEarnedView(image: communityViewModel.badge)
            }
        }.ignoresSafeArea()
    }

}

struct DiscoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPageView(communityViewModel: CommunityViewModel())
    }
}
