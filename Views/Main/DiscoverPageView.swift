//
//  DiscoverPageView.swift
//  mini2
//
//  Created by Randy Julian on 24/06/23.
//

import SwiftUI

struct DiscoverPageView: View {
    @State private var showcommunitydetail = false
    @State var text = ""
    @State private var showModal = false
    @State private var communityID = ""
    
    @ObservedObject private var communityViewmodel = CommunityViewmodel()
    
    var filteredCommunities: [Community] {
        if text.isEmpty {
            return communityViewmodel.communities
        } else {
            return communityViewmodel.communities.filter {
                $0.category.localizedCaseInsensitiveContains(text) ||
                $0.title.localizedCaseInsensitiveContains(text)
            }
        }
    }
    
    var body: some View {
        GeometryReader { geomtry in
            ZStack{
                HeaderComponent(text: "Explore the Network!")
                ZStack{
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: geomtry.size.width * 0.92, height: 51)
                            .foregroundColor(Color("Orange"))
                        
                        RoundedRectangle(cornerRadius: 50)
                            .frame(width: geomtry.size.width * 0.9 , height: 45)
                            .foregroundColor(Color("Gray"))
                        
                            .overlay {
                                HStack{
                                    Spacer()
                                    TextField("Search Your Community Here", text: $text)
                                    Image(systemName: "xmark.circle.fill")
                                        .foregroundColor(.gray)
                                    Spacer()
                                    
                                }
                            }
                    }.position(x: geomtry.size.width/2 , y: geomtry.size.height * 0.174)
                    
                    
                    VStack{
                        if !filteredCommunities.isEmpty {
                            List(filteredCommunities) { community in
                                ZStack{
                                    //community picture
                                    Image(community.image)
                                    
                                        .resizable()
                                        .frame(width: geomtry.size.width * 0.8 , height: geomtry.size.height * 0.19)
                                        .aspectRatio(contentMode: .fill)
                                        .clipped()
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 15)
                                                .foregroundColor(Color("DarkBlue"))
                                                .opacity(0.42)
                                        )
                                    
                                    
                                    VStack (alignment: .leading)  {
                                        
                                        Spacer()
                                        HStack{
                                            
                                            Text(community.title)
                                                .fontWeight(.bold)
                                                .font(.system(size: 19))
                                                .shadow(radius: 6, x: 2, y: 2)
                                            Spacer()
                                        }
                                        Spacer()
                                        HStack{
                                            Text("0")
                                                .fontWeight(.medium)
                                                .font(.system(size: 14))
                                        }
                                        
                                        
                                        Spacer()
                                        HStack{
                                            Button{
                                                
                                                communityViewmodel.joinCommunity(communityID: community.id)
                                                communityID = community.id
                                                showcommunitydetail = true
                                            }label: {
                                                CustomRoundedButton(text: "JOIN")
                                            }
                                            
                                        }
                                        
                                        Spacer()
                                    }.frame(width: geomtry.size.width * 0.76)
                                        .padding(.leading, geomtry.size.width * 0.052)
                                        .foregroundColor(.white)
                                    
                                }
                            }.listStyle(.plain)
                            
                        }else {
                            VStack{
                                
                                Button{
                                    showModal = true
                                }label: {
                                    CustomButton(text: "Create Community", primary: false)
                                }
                            }
                        }
                        
                    }.frame(width: geomtry.size.width * 0.9 , height: geomtry.size.height * 0.65)
                        .position(x: geomtry.size.width / 2 , y: geomtry.size.height * 0.58)
                    
                }
            }.onAppear{
                communityViewmodel.getCommunity()
            }
            .sheet(isPresented: $showModal){
                CreateCommunityPageView()
            }.sheet(isPresented: $showcommunitydetail) {
                DummyUI(CommunityViewModel: communityViewmodel, communityID: $communityID)
            }
        }
    }
    
}

struct DiscoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPageView()
    }
}
