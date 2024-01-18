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

class CommunityViewModel: ObservableObject {
    
    @Published var memberCount: Int = 0
//    @Published var userManager = UserViewModel()
    @Published var bvm = BadgeViewModel()
    @Published var communities = [Community]()
    @Published var joinedCommunities = [Community]()
    @Published var recommendedCommunities = [Community]()
    @Published var badge = ""
    @Published var showBadge = false
    @Published var showRespon = false
    @Published var alert = Alerts.memberIsFull
    @Published var isLoading = false
    @Published var newCommunityAdded = false
    var currentUser: UserModel?
    
    init() {
        Task {
            do {
                isLoading = true
                try await refreshCommunities()
            } catch {
                print(error)
            }
            isLoading = false
        }
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
    
    //MARK: GET SPECIFIC COMMUNITY
    func getCommunity(id: String) async throws -> Community? {
        return try await CommunityManager.shared.getCommunity(id)
    }
    
    
    //MARK: GET ALL COMMUNITY
    func getCommunities() async throws -> [Community] {
        let communities = try await CommunityManager.shared.getCommunities()
        self.communities = communities
        return communities
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
        
//        communities.append(community)
//        joinedCommunities.append(community)
//        try await refreshCommunities()
//        self.alert = Alerts.successCreateCommunity
//        self.showRespon.toggle()
    }
    
    func refreshCommunities() async throws {
//        isLoading = true
        communities = []
        joinedCommunities = []
        recommendedCommunities = []
        communities = try await getCommunities()
        try await getJoinedCommunity()
        getUserRecommendation()
//        isLoading = false
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
//                self.respons = "You have already joined this community."
                self.showRespon.toggle()
                return
            }
        }
        
        //check members availablility
        if members.count >= 6 {
            self.alert = Alerts.memberIsFull
            self.showRespon.toggle()
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
//        self.respons = "Successfully joined the community"
        
//        try await refreshCommunities()
        self.alert = Alerts.successJoinCommunity
        self.showRespon.toggle()
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
    func leaveCommunity(communityID: String) {
        guard let currentUser = currentUser else {
            print("no current user")
            return
        }
        //TODO: put this function in chatroomviewmodel
        Task {
            do {
                isLoading = true
                let members = try await getCommunityMembers(communityID: communityID)
                guard let userCommunityMember = members.filter({$0.id ==  currentUser.id}).first else {
                    print("user not joined in community")
                    return
                }
                
                CommunityManager.shared.deleteMember(communityID, userCommunityMember.documentID!)
                joinedCommunities.removeAll { community in
                    community.id == communityID
                }
            } catch {
                print(error)
            }
            isLoading = false
        }
        
    }
    
//    func leaveCommunity(communityID: String) {
//        guard let currentUserID = Auth.auth().currentUser?.uid else {
//            print("User is not authenticated or user ID could not be retrieved.")
//            return
//        }
//        let membersRef = db.collection("communities").document(communityID).collection("members")
//        let query = membersRef.whereField("id", isEqualTo: currentUserID)
//        query.getDocuments { [weak self] (querySnapshot, error) in
//            if let error = error {
//                print("Error removing member from community: \(error.localizedDescription)")
//            } else {
//                if let document = querySnapshot?.documents.first {
//                    membersRef.document(document.documentID).delete { error in
//                        if let error = error {
//                            print("Error removing member from community: \(error.localizedDescription)")
//                        } else {
//                            print("Member removed successfully")
//                        }
//                    }
//                } else {
//                    print("Member not found in the community")
//                }
//            }
//        }
//    }
    
    //MARK: GET USER JOINED COMMUNITY
    func getJoinedCommunity() async throws {
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
        self.memberCount = members.count
        return members
//        self.members = members
    }
    
    //MARK: USER RECOMMENDATION
    func getUserRecommendation() {
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
//    func setSchedule(startDate: Date, endDate: Date, communityID: String) {
//        let data: [String: Any] = [
//            "startDate": startDate,
//            "endDate": endDate
//        ]
//        
//        self.db.collection("communities").document(communityID).updateData(data) { error in
//            if let error = error {
//                print("Error updating schedule: \(error)")
//            } else {
//                NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
//            }
//        }
//    }
}
