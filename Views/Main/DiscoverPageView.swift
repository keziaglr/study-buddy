//
//  DiscoverPageView.swift
//  mini2
//
//  Created by Randy Julian on 24/06/23.
//

import SwiftUI

import SwiftUI

struct DiscoverPageView: View {
    
    @ObservedObject var communityViewModel: CommunityViewModel
    
    @State private var text = ""
    @State private var showModal = false
    @State private var communityID = ""
    
    var filteredCommunities: [Community] {
        if text.isEmpty {
            return communityViewModel.communities
        } else {
            return communityViewModel.communities.filter {
                $0.category.localizedCaseInsensitiveContains(text) ||
                $0.title.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geometry in
                ZStack {
                    HeaderComponent(text: "Explore the Network!")
                    
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
                    VStack {
                        if !filteredCommunities.isEmpty {
                            List(filteredCommunities) { community in
                                CommunityCell(community: community) {
                                    communityViewModel.joinCommunity(communityID: community.id)
                                    communityID = community.id
                                }
                            }.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.65)
                            .listStyle(.plain)
                        } else {
                            VStack {
                                Button {
                                    
                                    showModal = true
                                } label: {
                                    CustomButton(text: "Create Community", primary: false)
                                }
                            }
                        }
                    }
                    .frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.65)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.58)
                }
                .onAppear {
                    communityViewModel.getCommunity()
                }
                .sheet(isPresented: $showModal) {
                    CreateCommunityPageView(communityViewModel: CommunityViewModel())
                }
            }
    }
}



struct CommunityCell: View {
    let community: Community
    let joinAction: () -> Void
    
    var body: some View {
        ZStack {
            // Community picture
            AsyncImage(url: URL(string: community.image)) { image in
                image

                    .resizable()
                    .scaledToFit()
                    .frame(width: UIScreen.main.bounds.width*0.17811705, height: UIScreen.main.bounds.width*0.17811705)
                   
            } placeholder: {
                ProgressView()
            }
            

            
           
            
            VStack(alignment: .leading) {
                Spacer()
                
                HStack {
                    Text(community.title)
                        .fontWeight(.bold)
                        .font(.system(size: 19))
                        .shadow(radius: 6, x: 2, y: 2)
                    
                    Spacer()
                }
                
                Spacer()
                
                HStack {
                    Text("0")
                        .fontWeight(.medium)
                        .font(.system(size: 14))
                }
                
                Spacer()
                
                HStack {
                    Button(action: joinAction) {
                        CustomRoundedButton(text: "JOIN")
                    }
                }
                
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.76 , height: UIScreen.main.bounds.height * 0.1)
            .padding(.leading, UIScreen.main.bounds.width * 0.052)
            .foregroundColor(.white)
        }
    }
}

struct DiscoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPageView(communityViewModel: CommunityViewModel())
    }
}
