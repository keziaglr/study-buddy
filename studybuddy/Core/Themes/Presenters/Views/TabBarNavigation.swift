//
//  TabBarNavigation.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct TabBarNavigation: View {
    @EnvironmentObject var authenticationViewModel: AuthenticationViewModel
    @StateObject var communityViewModel = CommunityViewModel()
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack{
                TabView {
                    CommunityPageView()
                        .tabItem {
                            Image(systemName: "person.2.fill")
                            Text("Community")
                        }
                    
                    DiscoverPageView()
                        .tabItem {
                            Image(systemName: "magnifyingglass")
                            Text("Discover")
                        }
                    
                    ProfilePageView()
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
            authenticationViewModel.created = false
        })
        .task {
            do {
                communityViewModel.isLoading = true
                communityViewModel.currentUser = try await authenticationViewModel.getCurrentUser()
                try await communityViewModel.refreshCommunities()
            } catch {
                print(error)
            }
            communityViewModel.isLoading = false
        }
        .environmentObject(communityViewModel)
    }
}

struct TabBarNavigation_Previews: PreviewProvider {
    static var previews: some View {
        TabBarNavigation()
            .environmentObject(AuthenticationViewModel())
    }
}
