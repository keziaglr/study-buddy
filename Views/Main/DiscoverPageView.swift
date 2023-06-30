////
////  DiscoverPageView.swift
////  mini2
////
////  Created by Randy Julian on 24/06/23.
////
//
//import SwiftUI
//
import SwiftUI
//
struct DiscoverPageView: View {

    @ObservedObject var communityViewModel: CommunityViewModel
    @State var bvm = BadgeViewModel()
    @State private var text = ""
    @State private var showModal = false
    @State private var communityID = ""
    @State private var badge = Badge(id: "", name: "", image: "", description: "")

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

        ZStack{
            GeometryReader { geometry in
                HeaderComponent(text: "Explore the network")
                
                SearchBar(text: $text)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.21)
              

                if !filteredCommunities.isEmpty {
                    List(filteredCommunities) { community in
                        CommunityCell(community: community) {
                            communityViewModel.joinCommunity(communityID: community.id)
                            communityID = community.id
                        }.listRowSeparator(.hidden)
                    }.frame(width: geometry.size.width * 0.9, height: geometry.size.height * 0.6)
                        .listStyle(.plain)
                        .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.6)
                        .scrollIndicators(.hidden)

                }else {
                    CreateCommunityButton(showModal: $showModal)
                   .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.55)
                }


            }.onAppear {
                communityViewModel.getCommunity()
            }
            .sheet(isPresented: $showModal) {
                CreateCommunityPageView(communityViewModel: CommunityViewModel())
            }
            .sheet(isPresented: $communityViewModel.showBadge) {
                BadgeEarnedView(image: communityViewModel.badge)
            }
        }.ignoresSafeArea()
    }
}

struct CommunityCell: View {
    let community: Community
    let joinAction: () -> Void
    
    var body: some View {
        ZStack {
            communityImage
            VStack(alignment: .leading) {
                Spacer()
                communityTitle
                Spacer()
                memberCount
                Spacer()
                joinButton
                Spacer()
            }
            .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.1)
            .padding(.leading, UIScreen.main.bounds.width * 0.052)
            .foregroundColor(.white)
        }
    }
    
    private var communityImage: some View {
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
    
    private var communityTitle: some View {
        HStack {
            Text(community.title)
                .fontWeight(.bold)
                .font(.system(size: 19))
                .shadow(radius: 6, x: 2, y: 2)
            Spacer()
        }
    }
    
    private var memberCount: some View {
        HStack {
            Text("0") // Replace with the actual member count value
                .fontWeight(.medium)
                .font(.system(size: 14))
        }
    }
    
    private var joinButton: some View {
        HStack {
            Button(action: joinAction) {
                CustomRoundedButton(text: "JOIN")
            }
        }
    }
}







//struct CommunityCell: View {
//    let community: Community
//    let joinAction: () -> Void
//
//    var body: some View {
//        ZStack {
//            AsyncImage(url: URL(string: community.image)) { image in
//                image
//                    .resizable()
//                    .aspectRatio(contentMode: .fill)
//                    .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.15)
//                    .clipShape(RoundedRectangle(cornerRadius: 15))
//                    .overlay {
//                        RoundedRectangle(cornerRadius: 15)
//                            .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.15)
//                            .foregroundColor(Color("DarkBlue"))
//                            .opacity(0.42)
//                    }
//            } placeholder: {
//                ProgressView()
//            }
//
//            VStack(alignment: .leading) {
//                Spacer()
//
//                HStack {
//                    Text(community.title)
//                        .fontWeight(.bold)
//                        .font(.system(size: 19))
//                        .shadow(radius: 6, x: 2, y: 2)
//
//                    Spacer()
//                }
//
//                Spacer()
//
//                HStack {
//                    Text("0")
//                        .fontWeight(.medium)
//                        .font(.system(size: 14))
//                }
//
//                Spacer()
//
//                HStack {
//                    Button(action: joinAction) {
//                        CustomRoundedButton(text: "JOIN")
//                    }
//                }
//
//                Spacer()
//            }
//            .frame(width: UIScreen.main.bounds.width * 0.76, height: UIScreen.main.bounds.height * 0.1)
//            .padding(.leading, UIScreen.main.bounds.width * 0.052)
//            .foregroundColor(.white)
//        }
//    }
//}

struct DiscoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPageView(communityViewModel: CommunityViewModel())
    }
}
