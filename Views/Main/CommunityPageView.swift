//
//  CommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct CommunityPageView: View {
    
    @ObservedObject private var communityViewmodel = CommunityViewmodel()
    
    @State private var searchText = ""
    
    var filteredCommunities: [Community] {
        if searchText.isEmpty {
            return communityViewmodel.communities
        } else {
            return communityViewmodel.communities.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            HeaderComponent(text: "Your Learning Squad!")
            
            VStack(spacing: -100) {
                
              
                
            }
            .padding(.top, 180)
            
        }
    }
}

struct CommunityPageView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPageView()
    }
}
