//
//  TabBarNavigation.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct TabBarNavigation: View {
    var body: some View {
        TabView {
            NavigationView {
                CommunityPageView(communityViewModel: CommunityViewModel())
            }
                .tabItem {
                    Image(systemName: "person.2.circle.fill")
                    Text("Community")
                }
            NavigationView {
                DiscoverPageView(communityViewModel: CommunityViewModel())
            }
                .tabItem {
                    Image(systemName: "magnifyingglass.circle.fill")
                    Text("Discover")
                }
            
            NavigationView {
                ProfilePageView()
            }
                .tabItem {
                    Image(systemName: "person.crop.circle.fill")
                    Text("Profile")
                }
        }
        .background(Color.black)
    }
}

struct TTabBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabBarNavigation()
    }
}
