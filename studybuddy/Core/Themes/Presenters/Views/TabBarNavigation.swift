//
//  TabBarNavigation.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct TabBarNavigation: View {
    @State private var community = Community(id: "", title: "", description: "", image: "", category: "")
    @StateObject var userViewModel = UserViewModel()
    var body: some View {
        NavigationStack {
            ZStack{
                TabView {
                    CommunityPageView(communityViewModel: CommunityViewModel(), community: $community)
                        .tabItem {
                            Image(systemName: "person.2.fill")
                            Text("Community")
                        }
                    DiscoverPageView(communityViewModel: CommunityViewModel())
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Discover")
                        }
                    
                    ProfilePageView()
                        .environmentObject(userViewModel)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }.navigationBarBackButtonHidden()
                    .background(Color.black)
            }
        }
    }
}

struct TTabBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabBarNavigation()
    }
}
