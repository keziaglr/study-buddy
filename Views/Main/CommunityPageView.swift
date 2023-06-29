//
//  CommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct CommunityPageView: View {
    
    @ObservedObject var communityViewModel: CommunityViewModel
    @State private var text = ""
    @Binding var community : Community
    @Binding var showCommunityDetail : Bool
    
    var filteredCommunities: [Community] {
        if text.isEmpty {
            return communityViewModel.communities
        } else {
            return communityViewModel.communities.filter {
                $0.title.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    var body: some View {
        
        GeometryReader { geometry in
            ZStack {
                
                
                HeaderComponent(text: "Your Learning Squad!")
                
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: geometry.size.width * 0.92, height: 51)
                        .foregroundColor(Color("Orange"))
                    
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: geometry.size.width * 0.9 , height: 45)
                        .foregroundColor(Color("Gray"))
                    
                    HStack {
                        Spacer()
                        TextField("Search Your Community Here", text: $text)
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.gray)
                        Spacer()
                    }
                    .padding(.horizontal)
                }
                .frame(width: geometry.size.width, height: geometry.size.height * 0.1)
                .position(x: geometry.size.width/2 , y: geometry.size.height * 0.174)
             
                VStack{
                    List(filteredCommunities) { community in
                        CommunityCell(community: community){
                            self.community = community
                            showCommunityDetail = true
                        }

                    }.listStyle(.plain)
                }.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.65)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.58)
                    
                
                
            }
            .onAppear {
                communityViewModel.getJoinedCommunity()
            }
        }
    }
}

//struct CommunityPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CommunityPageView(communityViewModel: CommunityViewModel(), showCommunityDetail: .constant(false))
//
//    }
//}
