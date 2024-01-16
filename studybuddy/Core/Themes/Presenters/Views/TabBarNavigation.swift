//
//  TabBarNavigation.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct TabBarNavigation: View {
    @State private var community = Community(id: "", title: "", description: "", image: "", category: "")
    @EnvironmentObject var authVM: AuthenticationViewModel
    @Environment(\.presentationMode) var presentationMode
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
                        .environmentObject(authVM)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .navigationBarBackButtonHidden()
                .background(Color.black)
            }
        }
        .onChange(of: authVM.authenticated, perform: { value in
            presentationMode.wrappedValue.dismiss()
        })
    }
}

struct TTabBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabBarNavigation()
            .environmentObject(AuthenticationViewModel())
    }
}
