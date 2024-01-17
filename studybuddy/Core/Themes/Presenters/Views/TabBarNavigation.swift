//
//  TabBarNavigation.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct TabBarNavigation: View {
    @State private var community = Community(id: "", title: "", description: "", image: "", category: "")
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var communityViewModel = CommunityViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack{
                TabView {
                    CommunityPageView(community: $community)
                        .environmentObject(communityViewModel)
                        .tabItem {
                            Image(systemName: "person.2.fill")
                            Text("Community")
                        }
                    
                    DiscoverPageView()
                        .environmentObject(communityViewModel)
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Discover")
                        }
                    
                    ProfilePageView()
                        .environmentObject(authenticationViewModel)
                        .tabItem {
                            Image(systemName: "person.fill")
                            Text("Profile")
                        }
                }
                .navigationBarBackButtonHidden()
                .background(Color.black)
            }
        }
        .onChange(of: authenticationViewModel.authenticated, perform: { value in
            presentationMode.wrappedValue.dismiss()
        })
        .task {
            do {
                communityViewModel.currentUser = try await authenticationViewModel.getCurrentUser()
            } catch {
                print(error)
            }
        }
    }
}

struct TTabBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabBarNavigation()
            .environmentObject(AuthenticationViewModel())
    }
}
