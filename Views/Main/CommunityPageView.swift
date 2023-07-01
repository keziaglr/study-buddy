//
//  CommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct CommunityPageView: View {
    
    @StateObject var communityViewModel: CommunityViewModel
    @State private var text = ""
    @Binding var community : Community
    @Binding var showCommunityDetail : Bool
    
    var filteredCommunities: [Community] {
        if text.isEmpty {
            return communityViewModel.jCommunities
        } else {
            return communityViewModel.jCommunities.filter {
                $0.title.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                
                HeaderComponent(text: "Your Learning Squad!")
                
                SearchBar(text: $text)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.21)
                
                Text("Recommended Community : ")
                    .font(.system(size: 20))
                    .position(x: geometry.size.width * 0.425 , y: geometry.size.height * 0.28)
                
                List(communityViewModel.rcommunities) { community in
                    CommunityCell(community: community) {
                        communityViewModel.joinCommunity(communityID: community.id)
                    }.listRowSeparator(.hidden)
                    
                }.frame(width: geometry.size.width * 0.9 , height:  geometry.size.height * 0.2)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.42)
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                
                Text("Joined Community : ")
                    .font(.system(size: 20))
                    .position(x: geometry.size.width * 0.35 , y: geometry.size.height * 0.55)
                
                List(filteredCommunities) { community in
                    CommunityCell2(community: community){
                        self.community = community
                        showCommunityDetail = true
                    
                    }.listRowSeparator(.hidden)
                }
                .frame(width: geometry.size.width * 0.9 , height:  geometry.size.height * 0.35)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.75)
                    .listStyle(.plain)
                    .scrollIndicators(.hidden)
                
        
                
                
                
                
                
            }
            
        }.ignoresSafeArea()
            .onAppear {
                communityViewModel.getRecommendation()
                communityViewModel.getJoinedCommunity()
            }
    }
}

struct CommunityCell2: View {
    let community: Community
    let joinAction: () -> Void
    
    var body: some View {
        ZStack {
            communityImage2
            VStack(alignment: .leading) {
                Spacer()
                communityTitle2
                Spacer()
                memberCount2
                Spacer()
                openButton
                Spacer()
             
            }
            .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.1)
            .padding(.leading, UIScreen.main.bounds.width * 0.052)
            .foregroundColor(.white)
        }
    }
    
    private var communityImage2: some View {
        AsyncImage(url: URL(string: community.image)) { image in
            image
                .resizable()
                .aspectRatio(contentMode: .fill)
                .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.15)
                .clipShape(RoundedRectangle(cornerRadius: 15))
                .overlay {
                    RoundedRectangle(cornerRadius: 15)
                        .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.15)
                        .foregroundColor(Color("DarkBlue"))
                        .opacity(0.42)
                }
        } placeholder: {
            ProgressView()
        }
    }
    
    private var communityTitle2: some View {
        HStack {
            Text(community.title)
                .fontWeight(.bold)
                .font(.system(size: 19))
                .shadow(radius: 6, x: 2, y: 2)
            Spacer()
        }
    }
    
    private var memberCount2: some View {
        HStack {
            Text("0") // Replace with the actual member count value
                .fontWeight(.medium)
                .font(.system(size: 14))
        }
    }
    
    private var openButton: some View {
        HStack {
            Button(action: joinAction) {
                CustomRoundedButton(text: "Open")
            }
        }
    }
}

