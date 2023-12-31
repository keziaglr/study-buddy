//
//  TabBarNavigation.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct TabBarNavigation: View {
    @State private var showTabView = false
    @State private var community = Community(id: "", title: "", description: "", image: "", category: "")
    var body: some View {
        NavigationStack {
            ZStack{
                    TabView {
                        NavigationView {
                            CommunityPageView(communityViewModel: CommunityViewModel(), community: $community, showCommunityDetail: $showTabView)
                        }
                        .tabItem {
                            Image(systemName: "person.2.fill")
                            Text("Community")
                        }
                        NavigationView {
                            DiscoverPageView(communityViewModel: CommunityViewModel())
                        }
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Discover")
                        }
                        
                        NavigationView {
                            ProfilePageView()
                        }
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                    }.navigationBarBackButtonHidden()
                        .background(Color.black)
            }.navigationDestination(isPresented: $showTabView) {
                ChatRoomView(manager: ChatViewModel(), showTabView: $showTabView, community: $community)
            }
        }
    }
}

struct TTabBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabBarNavigation()
    }
}
