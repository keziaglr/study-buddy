//
//  CommunityViewModel.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 25/06/23.
//

import Foundation
import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseStorage

@MainActor
class CommunityViewModel: ObservableObject {
    
    //    @Published var memberCount: Int = 0
    @Published var bvm = BadgeViewModel()
    @Published var communities = [Community]()
    @Published var joinedCommunities = [Community]()
    @Published var recommendedCommunities = [Community]()
    @Published var badge = ""
    @Published var showBadge = false
    @Published var communityAlert = false
    @Published var alert = Alerts.memberIsFull
    @Published var isLoading = false
    @Published var newCommunityAdded = false
    @Published var chatRoomAlert = false
    var currentUser: UserModel?
    
    init() {
    }
    //MARK: GET SPECIFIC COMMUNITY
    func getCommunity(id: String) async throws -> Community? {
        return try await CommunityManager.shared.getCommunity(id)
    }
    
    
    //MARK: GET ALL COMMUNITY
    func getCommunities() async throws {
        let communities = try await CommunityManager.shared.getCommunities()
        self.communities = communities
    }
    
    //MARK: ADD NEW COMMUNITY
    func addCommunity(title: String, description: String, url: URL, category: String) async throws {
        var imageURL = URL(string: "")
        if url.absoluteString != "" {
            imageURL = try await StorageManager.shared.saveCommunityImage(url: url)
        }
        
        let community = Community(title: title, description: description, image: imageURL?.absoluteString ?? url.absoluteString, category: category)
        
        guard let currentUser = currentUser else {
            print("no current user")
            return
        }
        
        let communityCreator = CommunityMember(id: currentUser.id!, name: currentUser.name, image: currentUser.image)
        
        CommunityManager.shared.addCommunity(community: community, creator: communityCreator)
    }
    
    func refreshCommunities() async throws {
        try await getCommunities()
        try await getJoinedCommunity()
        getUserRecommendation()
    }
    
    //MARK: JOIN COMMUNITY
    func joinCommunity(community: Community) async throws {
        //check user already join or not
        guard let communityID = community.id else {
            print("no community id")
            return
        }
        let members = try await getCommunityMembers(communityID: communityID)
        
        for member in members {
            if member.id == currentUser?.id {
                //                self.communityAlert.toggle()
                return
            }
        }
        
        //check members availablility
        if members.count >= 6 {
            self.alert = Alerts.memberIsFull
            self.communityAlert.toggle()
            return
        }
        
        //join the member to community
        guard let currentUser = currentUser else {
            print("no current user")
            return
        }
        let newMember = CommunityMember(id: currentUser.id!, name: currentUser.name, image: currentUser.image)
        CommunityManager.shared.addMember(communityID, newMember)
        joinedCommunities.append(community)
        
        self.alert = Alerts.successJoinCommunity
        self.communityAlert.toggle()
    }
    
    //MARK: VALIDATE BADGE
    func validateBadge(communityID: String){
        if joinedCommunities.count == 2 {
            let badgeId = self.bvm.getBadgeID(badgeName: "Learning Luminary") // if joined > 2 communities
            bvm.validateBadge(badgeId: badgeId) { b in
                if !b{
                    self.showBadge = true
                    self.badge = "Learning Luminary"
                    self.bvm.achieveBadge(badgeId: badgeId)
                }
            }
        } else {
            let badgeId = self.bvm.getBadgeID(badgeName: "Engaged Explorer")
            let community = communities.first(where: {$0.id == communityID})
            for joinedCommunity in joinedCommunities {
                if joinedCommunity.category != community?.category { // if the user join new community with different category with current joined community
                    self.bvm.validateBadge(badgeId: badgeId) { b in
                        if !b{
                            self.showBadge = true
                            self.badge = "Engaged Explorer"
                            self.bvm.achieveBadge(badgeId: badgeId)
                        }
                    }
                }
            }
            //            getCommunity(id: communityID) { c in
            //                for jc in self.jCommunities {
            //                    if jc.category != c?.category{
            //                        self.bvm.validateBadge(badgeId: badgeId) { b in
            //                            if !b{
            //                                self.showBadge = true
            //                                self.badge = "Engaged Explorer"
            //                                self.bvm.achieveBadge(badgeId: badgeId)
            //                            }
            //                        }
            //                    }
            //                }
            //            }
        }
    }
    
    
    //MARK: LEAVE COMMUNITY
    func leaveCommunity(communityID: String, communityMembers: [CommunityMember]) {
        guard let currentUser = currentUser else {
            print("no current user")
            return
        }
        guard let userCommunityMember = communityMembers.filter({$0.id ==  currentUser.id}).first else {
            print("user not joined in community")
            return
        }
        
        CommunityManager.shared.deleteMember(communityID, userCommunityMember.documentID!)
        joinedCommunities.removeAll { community in
            community.id == communityID
        }
    }
    
    //MARK: GET USER JOINED COMMUNITY
    func getJoinedCommunity() async throws {
        joinedCommunities = []
        for community in communities {
            // get members in each communities
            let members = try await CommunityManager.shared.getMembers(community.id!)
            
            // check is currentUser joined in members
            let member = members.filter({$0.id == currentUser?.id}).first
            
            // if member exist / user i joined then append the community to jCommunities
            if member != nil {
                joinedCommunities.append(community)
            }
        }
    }
    
    //MARK: GET COMMUNITY MEMBER
    func getCommunityMembers(communityID: String) async throws -> [CommunityMember] {
        let members = try await CommunityManager.shared.getMembers(communityID)
        return members
    }
    
    //MARK: USER RECOMMENDATION
    func getUserRecommendation() {
        recommendedCommunities = []
        for community in communities {
            if ((currentUser?.category.contains(community.category)) != nil) {
                recommendedCommunities.append(community)
            }
        }
    }
    
    //MARK: SET SCHEDULE
    func setSchedule(startDate: Date, endDate: Date, communityID: String) async throws {
        let data: [String: Any] = [
            "startDate": startDate,
            "endDate": endDate
        ]
        try await CommunityManager.shared.setCommunitySchedule(communityID: communityID, data: data)
    }
    
    func validateCommunityJoined(communityID: String) -> Bool {
        return !joinedCommunities.contains { jCom in
            jCom.id == communityID
        }
    }
    
    func dateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"//"EE" to get short style
        let mydt = dateFormatter.string(from: date).capitalized
        
        return "\(mydt)"
    }
    
}
