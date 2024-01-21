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
import EventKit

@MainActor
class CommunityViewModel: ObservableObject {
    
    @Published var communities = [Community]()
    @Published var joinedCommunities = [Community]()
    @Published var recommendedCommunities = [Community]()
    @Published var showedBadge = ""
    @Published var isLoading = false
    @Published var newCommunityAdded = false
    @Published var chatRoomAlert = false
    var userManager = UserManager.shared
    var badgeManager = BadgeManager.shared
    
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
        
        guard let currentUser = userManager.currentUser else {
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
            if member.id == userManager.currentUser?.id {
                throw CommunityError.alreadyJoined
            }
        }
        
        //check members availablility
        if members.count >= 6 {
            throw CommunityError.memberIsFull
        }
        
        //join the member to community
        guard let currentUser = userManager.currentUser else {
            print("no current user")
            return
        }
        let newMember = CommunityMember(id: currentUser.id!, name: currentUser.name, image: currentUser.image)
        //add user to member subcollection
        CommunityManager.shared.addMember(communityID, newMember)
        
        //update the joinedCommunities array
        joinedCommunities.append(community)
        
        //add community to user field
        var userCommunities = currentUser.communities
        userCommunities.append(communityID)
        try await userManager.updateCommunity(communities: userCommunities)
        
    }
    
    //MARK: VALIDATE BADGE
    func validateBadgeWhenJoinCommunity(community: Community) async throws -> Bool {
        if joinedCommunities.count == 2 {
            let hasBadge = badgeManager.validateBadge(badgeName: Badges.learningLuminary) // if joined > 2 communities
            if hasBadge == false {
                showedBadge = Badges.learningLuminary
                try await badgeManager.achieveBadge(badgeName: showedBadge)
                return true
            } else {
                return false
            }
        } else {
            let hasBadge = badgeManager.validateBadge(badgeName: Badges.engagedExplorer) // if the user join new community with different category with current joined community and currently has more or less than 2 communities
            if hasBadge == false {
                for joinedCommunity in joinedCommunities {
                    if joinedCommunity.category != community.category {
                        showedBadge = Badges.engagedExplorer
                        try await badgeManager.achieveBadge(badgeName: showedBadge)
                        return true
                    }
                }
            } else {
                return false
            }
        }
        return false
//        if joinedCommunities.count == 2 {
//            let badgeId = self.bvm.getBadgeID(badgeName: "Learning Luminary") // if joined > 2 communities
//            bvm.validateBadge(badgeId: badgeId) { b in
//                if !b{
//                    self.showBadge = true
//                    self.badge = "Learning Luminary"
//                    self.bvm.achieveBadge(badgeId: badgeId)
//                }
//            }
//        } else {
//            let badgeId = self.bvm.getBadgeID(badgeName: "Engaged Explorer")
//            let community = communities.first(where: {$0.id == communityID})
//            for joinedCommunity in joinedCommunities {
//                if joinedCommunity.category != community?.category { // if the user join new community with different category with current joined community
//                    self.bvm.validateBadge(badgeId: badgeId) { b in
//                        if !b{
//                            self.showBadge = true
//                            self.badge = "Engaged Explorer"
//                            self.bvm.achieveBadge(badgeId: badgeId)
//                        }
//                    }
//                }
//            }
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
//        }
    }
    
    
    //MARK: LEAVE COMMUNITY
    func leaveCommunity(communityID: String, communityMembers: [CommunityMember]) async throws {
        guard let currentUser = userManager.currentUser else {
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
        
        
        //remove community to from user field
        var userCommunities = currentUser.communities
        userCommunities.removeAll { uCom in
            uCom == communityID
        }
        try await userManager.updateCommunity(communities: userCommunities)
    }
    
    //MARK: GET USER JOINED COMMUNITY
    func getJoinedCommunity() async throws {
        joinedCommunities = []
        let userCommunities = userManager.currentUser?.communities
        for community in communities {
//            // get members in each communities
//            let members = try await CommunityManager.shared.getMembers(community.id!)
//            
//            // check is currentUser joined in members
//            let member = members.filter({$0.id == userManager.currentUser?.id}).first
            
//            // if member exist / user i joined then append the community to jCommunities
//            if member != nil {
//                joinedCommunities.append(community)
//            }
            
            if userManager.currentUser?.communities.contains(community.id!) == true {
                joinedCommunities.append(community)
            }
        }
    }
    
    //MARK: GET COMMUNITY MEMBER
    func getCommunityMembers(communityID: String) async throws -> [CommunityMember] {
        var members = try await CommunityManager.shared.getMembers(communityID)
        guard let currentUser = userManager.currentUser else {
                return members
            }

        for index in 0..<members.count {
            if members[index].id == currentUser.id {
                members[index].image = currentUser.image
            }
        }
        return members
    }
    
    //MARK: USER RECOMMENDATION
    func getUserRecommendation() {
        recommendedCommunities = []
        for community in communities {
            if userManager.currentUser?.category.contains(community.category) == true {
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
    
    func addEventToCalendar(community: Community) async throws {
        let eventStore = EKEventStore()
        if #available(iOS 17.0, *) {
            let grantedAccess = try await eventStore.requestFullAccessToEvents()
            if grantedAccess == true {
                let event = EKEvent(eventStore: eventStore)
                event.title = "\(community.title)'s Study Schedule"
                event.startDate = community.startDate
                event.endDate = community.endDate
                
                
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Event added to calendar")
                } catch {
                    print("Error saving event: \(error.localizedDescription)")
                }
            } else {
                print("Access denied or error")
            }
        } else {
            // Fallback on earlier versions
            let grantedAccess = try await eventStore.requestAccess(to: .event)
            if grantedAccess == true {
                let event = EKEvent(eventStore: eventStore)
                event.title = "\(community.title)'s Study Schedule"
                event.startDate = community.startDate
                event.endDate = community.endDate
                
                
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Event added to calendar")
                } catch {
                    print("Error saving event: \(error.localizedDescription)")
                }
            } else {
                print("Access denied or error")
            }
        }
    }
    
    func validateGetCollaborativeDynamoBadge() async throws -> Bool {
//      let badgeId = badgeManager.getBadgeID(badgeName: Badges.collaborativeDynamo)
        if badgeManager.validateBadge(badgeName: Badges.collaborativeDynamo) == false {
            try await badgeManager.achieveBadge(badgeName: Badges.collaborativeDynamo)
            self.showedBadge = Badges.collaborativeDynamo
            return true
        }
        return false
    }
    
    func validateCommunityJoined(communityID: String) -> Bool {
        return !joinedCommunities.contains { jCom in
            jCom.id == communityID
        }
    }
    
}

enum CommunityError: Error {
    case memberIsFull
    case alreadyJoined
}
