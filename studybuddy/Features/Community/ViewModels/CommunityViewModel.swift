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
    @Published var userManager = UserViewModel()
    @Published var bvm = BadgeViewModel()
    @Published var communities = [Community]()
    @Published var joinedCommunities = [Community]()
    @Published var recommendedCommunities = [Community]()
    @Published var members = [CommunityMember]()
    @Published var badge = ""
    @Published var showBadge = false
    @Published var showRespon = false
    @Published var respons = ""
//    var db = Firestore.firestore()
//    let storageRef = Storage.storage().reference()
    var currentUser: UserModel?
    
    init() {
        Task {
            communities = try await getCommunities()
            try await getJoinedCommunity()
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
    
//    func getCommunity(id: String, completion: @escaping (Community?) -> Void){
//        db.collection("communities").document(id).getDocument { (documentSnapshot, error) in
//            if let error = error {
//                print("Error getting community: \(error)")
//                completion(nil)
//                return
//            }
//            guard let document = documentSnapshot else {
//                print("Communities document does not exist")
//                completion(nil)
//                return
//            }
//            
//            if document.exists {
//                let data = document.data()
//                let documentID = document.documentID
//                let title = data?["title"] as? String ?? ""
//                let image = data?["image"] as? String ?? ""
//                let description = data?["description"] as? String ?? ""
//                let category = data?["category"] as? String ?? ""
//                let startDate = data?["startDate"] as? Date ?? nil
//                let endDate = data?["endDate"] as? Date ?? nil
//                let community = Community(id: documentID, title: title, description: description, image: image, category: category, startDate: startDate, endDate: endDate)
//                
//                print("Retrieved user: \(community)")
//                completion(community)
//            } else {
//                print("Communities document does not exist")
//                completion(nil)
//            }
//        }
//    }
    
    
    //MARK: GET ALL COMMUNITY
    func getCommunities() async throws -> [Community] {
        let communities = try await CommunityManager.shared.getCommunities()
        self.communities = communities
        return communities
    }
//    func getCommunities() {
//        db.collection("communities").addSnapshotListener { [weak self] (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No Documents")
//                return
//            }
//            
//            
//            let communities = documents.compactMap { (queryDocumentSnapshot) -> Community? in
//                let documentID = queryDocumentSnapshot.documentID
//                let data = queryDocumentSnapshot.data()
//                let title = data["title"] as? String ?? ""
//                let image = data["image"] as? String ?? ""
//                let description = data["description"] as? String ?? ""
//                let category = data["category"] as? String ?? ""
//                return Community(id: documentID, title: title, description: description, image: image, category: category)
//            }
//            
//            DispatchQueue.main.async {
//                self?.communities = communities
//            }
//        }
//    }
    
    //MARK: ADD NEW COMMUNITY
    func addCommunity(title: String, description: String, url: URL, category: String) async throws {
        var imageURL = URL(string: "")
        if url.absoluteString != "" {
            imageURL = try await StorageManager.shared.saveCommunityImage(url: url)
        }
        
        let community = Community(title: title, description: description, image: imageURL?.absoluteString ?? url.absoluteString, category: category)
        
        CommunityManager.shared.addCommunity(community: community)
    }
//    func addCommunity(title: String, description: String, url: URL, category: String) {
//        let uid = UUID().uuidString
//        let date = dateFormatting()
//        let filePath = "\(date)-\(url.lastPathComponent)"
//        storageRef.child("communities").child(filePath).putFile(from: url, metadata: nil) { metadata, error in
//            if let error = error {
//                print("Error uploading file to Firebase Storage: \(error.localizedDescription)")
//            } else {
//                print("File uploaded successfully.")
//                
//                self.storageRef.child("communities/\(filePath)").downloadURL { (url, error) in
//                    if let error = error {
//                        print("Error getting download URL: \(error.localizedDescription)")
//                    } else if let downloadURL = url {
//                        print("Download URL: \(downloadURL.absoluteString)")
//                        do {
//                            let newCommunity = Community(id: uid, title: title, description: description, image: downloadURL.absoluteString, category: category, startDate: nil, endDate: nil)
//                            try self.db.collection("communities").document(uid).setData(from: newCommunity)
//                        } catch {
//                            print(error)
//                        }
//                    }
//                }
//            }
//        }
//    }
    
    
    //MARK: JOIN COMMUNITY
    func joinCommunity(communityID: String) async throws {
        //check user already join or not
        for member in members {
            if member.id == currentUser?.id {
                self.respons = "You have already joined this community."
                self.showRespon.toggle()
                return
            }
        }
        
        //check members availablility
        if members.count >= 6 {
            self.respons = "The community already has 6 members. You cannot join at the moment."
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
        self.respons = "Successfully joined the community"
        self.showRespon.toggle()
    }
//    func joinCommunity(communityID: String) {
//        userManager.getUser(id: Auth.auth().currentUser?.uid ?? "") { [weak self] user in
//            if let user = user {
//                let newMember = CommunityMember(id: user.id!, name: user.name, image: user.image)
//                
//                let membersRef = self?.db.collection("communities").document(communityID).collection("members")
//                
//                membersRef?.whereField("id", isEqualTo: user.id as Any).getDocuments { [weak self] (querySnapshot, error) in
//                    if let error = error {
//                        print("Error checking community members: \(error.localizedDescription)")
//                        return
//                    }
//                    
//                    if let documents = querySnapshot?.documents, !documents.isEmpty {
//                        self?.respons = "You have already joined this community."
//                        self?.showRespon.toggle()
//                        return
//                    }
//                    membersRef?.getDocuments(completion: { (snapshot, error) in
//                        if let error = error {
//                            print("Error checking community member count: \(error.localizedDescription)")
//                            return
//                        }
//                        
//                        if let memberCount = snapshot?.documents.count, memberCount >= 6 {
//                            self?.respons = "The community already has 6 members. You cannot join at the moment."
//                            self?.showRespon.toggle()
//                            return
//                        }
//                        
//                        do {
//                            try membersRef?.document().setData(from: newMember)
//                            self?.respons = "Successfully joined the community"
//                            self?.showRespon.toggle()
//                            
//                            self!.validateBadge(communityID: communityID)
//                        } catch {
//                            print("Error joining community: \(error.localizedDescription)")
//                        }
//                    })
//                }
//            } else {
//                print("No user found")
//            }
//        }
//    }
    
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
        guard let userCommunityMember = members.filter({$0.id ==  currentUser.id}).first else {
            print("user not joined in community")
            return
        }
        
        CommunityManager.shared.deleteMember(communityID, userCommunityMember.documentID!)
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
//    func getJoinedCommunity() {
//        guard let userId = Auth.auth().currentUser?.uid else {
//            print("User is not authenticated or user ID could not be retrieved.")
//            return
//        }
//        let communitiesRef = db.collection("communities")
//        communitiesRef.getDocuments { [weak self] (querySnapshot, error) in
//            if let error = error {
//                print("Error getting community documents: \(error)")
//                return
//            }
//            
//            guard let documents = querySnapshot?.documents else {
//                print("No matching communities found")
//                return
//            }
//            var joinedCommunities = [Community]() // Create an empty array to store joined communities
//            for document in documents {
//                let communityID = document.documentID
//                let membersRef = communitiesRef.document(communityID).collection("members")
//                
//                membersRef.whereField("id", isEqualTo: userId).getDocuments { [weak self] (membersSnapshot, membersError) in
//                    if let membersError = membersError {
//                        print("Error getting members documents: \(membersError)")
//                        return
//                    }
//                    
//                    if let membersDocument = membersSnapshot?.documents.first {
//                        let data = document.data()
//                        
//                        let id = membersDocument.documentID
//                        let title = data["title"] as? String ?? ""
//                        let description = data["description"] as? String ?? ""
//                        let image = data["image"] as? String ?? ""
//                        let category = data["category"] as? String ?? ""
//                        let startDateTimestamp = data["startDate"] as? Timestamp ?? nil
//                        let startDate = (startDateTimestamp != nil) ? Date(timeIntervalSince1970: TimeInterval(startDateTimestamp!.seconds)) : nil
//                        let endDateTimestamp = data["endDate"] as? Timestamp ?? nil
//                        let endDate = (endDateTimestamp != nil) ? Date(timeIntervalSince1970: TimeInterval(endDateTimestamp!.seconds)) : nil
//                        let community = Community(id: communityID, title: title, description: description, image: image, category: category, startDate: startDate, endDate: endDate)
//                        
//                        joinedCommunities.append(community) // Add the joined community to the array
//                        
//                        print("Community ID: \(communityID), Title: \(title), Description: \(description), Image: \(image) \(endDateTimestamp) \(startDateTimestamp)")
//                    }
//                    DispatchQueue.main.async {
//                        self?.jCommunities = joinedCommunities
//                    }
//                }
//            }
//        }
//    }
    
    //MARK: GET COMMUNITY MEMBER
    func getCommunityMembers(communityID: String) async throws {
        let members = try await CommunityManager.shared.getMembers(communityID)
        self.members = members
        self.memberCount = members.count
    }
//    func getMembers(communityId: String) {
//        db.collection("communities").document(communityId).collection("members").addSnapshotListener { [weak self] (querySnapshot, error) in
//            guard let documents = querySnapshot?.documents else {
//                print("No Documents")
//                return
//            }
//            let members = documents.compactMap { (queryDocumentSnapshot) -> CommunityMember? in
//                let data = queryDocumentSnapshot.data()
//                let name = data["name"] as? String ?? ""
//                let id = data["id"] as? String ?? ""
//                let image = data["image"] as? String ?? ""
//                print(name)
//                print(id)
//                return CommunityMember(id: id, name: name, image: image)
//            }
//            DispatchQueue.main.async {
//                self?.members = members
//                self?.memberCount = members.count
//            }
//        }
//    }
    
    //MARK: USER RECOMMENDATION
    func getUserRecommendation() {
        for community in communities {
            if ((currentUser?.category.contains(community.category)) != nil) {
                recommendedCommunities.append(community)
            }
        }
    }
//    func userRecommendation() {
//        guard let currentUserID = Auth.auth().currentUser?.uid else {
//            print("User is not authenticated or user ID could not be retrieved.")
//            return
//        }
//        
//        userManager.getUser(id: currentUserID) { user in
//            
//            if let interest = user?.category {
//                self.db.collection("communities").whereField("category", in: interest).getDocuments { (querySnapshot, error) in
//                    if let error = error {
//                        print("Error getting community documents: \(error)")
//                        return
//                    }
//                    
//                    guard let documents = querySnapshot?.documents else {
//                        print("No matching communities found")
//                        return
//                    }
//                    
//                    let communities = documents.compactMap { (queryDocumentSnapshot) -> Community? in
//                        let documentID = queryDocumentSnapshot.documentID
//                        let data = queryDocumentSnapshot.data()
//                        let title = data["title"] as? String ?? ""
//                        let description = data["description"] as? String ?? ""
//                        let image = data["image"] as? String ?? ""
//                        let category = data["category"] as? String ?? ""
//                        return Community(id: documentID, title: title, description: description, image: image, category: category)
//                    }
//                    
//                    DispatchQueue.main.async {
//                        self.rcommunities = communities
//                    }
//                    
//                    print("Matching Communities: \(communities)")
//                }
//            }
//        }
//    }
    
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
