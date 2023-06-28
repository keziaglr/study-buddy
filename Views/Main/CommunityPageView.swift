//
//  CommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct CommunityPageView: View {
    
    @ObservedObject var communityViewModel: CommunityViewModel
    @State private var searchText = ""
    @Binding var community : Community
    @Binding var showCommunityDetail : Bool
    
    var filteredCommunities: [Community] {
        if searchText.isEmpty {
            return communityViewModel.communities
        } else {
            return communityViewModel.communities.filter {
                $0.title.localizedCaseInsensitiveContains(searchText)
            }
        }
    }
    
    var body: some View {
        ZStack {
            HeaderComponent(text: "Your Learning Squad!")
            List(filteredCommunities) { community in
                CommunityCell(community: community){
                    self.community = community
                    showCommunityDetail = true
                }
            }
            
        }
        .onAppear {
            communityViewModel.getJoinedCommunity()
        }
    }
}

//struct CommunityPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityPageView(COmmuni)
////            .environmentObject(CommunityViewModel())
//    }
//}
