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
    @Published var showedBadge: Badge?
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
        
        let documentID = CommunityManager.shared.addCommunity(community: community, creator: communityCreator)
        
        //add community to user field
        var userCommunities = currentUser.communities
        userCommunities.append(documentID)
        try await userManager.updateCommunity(communities: userCommunities)
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
        if joinedCommunities.count == 3 {
            let hasBadge = badgeManager.validateBadge(badgeName: Badges.learningLuminary) // if joined > 2 communities
            if hasBadge == false {
                showedBadge = badgeManager.getBadge(badgeName: Badges.learningLuminary)
                try await badgeManager.achieveBadge(badgeName: Badges.learningLuminary)
                return true
            } else {
                return false
            }
        } else {
            let hasBadge = badgeManager.validateBadge(badgeName: Badges.engagedExplorer) // if the user join new community with different category with current joined community and currently has more or less than 2 communities
            if hasBadge == false {
                for joinedCommunity in joinedCommunities {
                    if joinedCommunity.category != community.category {
                        showedBadge = badgeManager.getBadge(badgeName: Badges.engagedExplorer)
                        try await badgeManager.achieveBadge(badgeName: Badges.engagedExplorer)
                        return true
                    }
                }
            } else {
                return false
            }
        }
        return false
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
            self.showedBadge = badgeManager.getBadge(badgeName: Badges.collaborativeDynamo)
            return true
        }
        return false
    }
    
    func validateCommunityJoined(communityID: String) -> Bool {
        return !joinedCommunities.contains { jCom in
            jCom.id == communityID
        }
    }
    
    func getLastChat(communityID: String) async throws -> Chat? {
        return try await ChatManager.shared.getLatestChat(communityID: communityID)
    }
    
    //MARK: GET UNREAD CHAT COUNT
//    func getUnreadChatCount(communityID: String) async throws -> Int? {
//        guard let currentUser = userManager.currentUser else {
//            print("no current user")
//            return nil
//        }
//        let userMember = try await CommunityManager.shared.getMember(communityID, currentUser.id!)
//        let count = try await ChatManager.shared.getUnreadChatCount(communityID: communityID, lastOpenedDate: userMember.lastChatDate)
//    }
    
}

enum CommunityError: Error {
    case memberIsFull
    case alreadyJoined
}
