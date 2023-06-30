//
//  LibraryViewModel.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 27/06/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import Firebase

class LibraryViewModel: ObservableObject {
    @Published var libraries = [Library]()
    @Published var isEmpty = false
    @Published var isLoading = false
    @Published var showFileViewer = false
    @Published var selectedFileURL: URL? = nil
    @Published var selectedFilePathForDownload: String? = nil
    @Published var showAchievedBadge = false
    @Published private var bm = BadgeViewModel()
    @Published private var um = UserViewModel()
    @Published var badgeImageURL = ""
    
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    
    func showLoader() -> Bool {
        return self.isLoading || (self.libraries.count == 0 && !self.isEmpty)
    }
    
    func showFileViewer(library: Library) {
        self.isLoading = true
        let starsRef = storageRef.child(library.url)
        
        // Fetch the download URL
        starsRef.downloadURL { url, error in
            self.isLoading = false
            if let error = error {
                print(error)
                // Handle any errors
            } else {
                self.selectedFileURL = url?.absoluteURL
                self.selectedFilePathForDownload = library.url
                self.showFileViewer.toggle()
            }
        }
    }
    
    func downloadLibrary() {
        self.isLoading = true
        let starsRef = storageRef.child(self.selectedFilePathForDownload!)

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        
        let fileName = URL(filePath: self.selectedFilePathForDownload!).lastPathComponent
        let localURL = documentsURL.appendingPathComponent(fileName)
        
        saveToLocal(localURL: localURL, starsRef: starsRef)
    }
    
    func saveToLocal(localURL: URL, starsRef: StorageReference) {
        // Download the image from Firebase Storage
        starsRef.write(toFile: localURL) { url, error in
            self.isLoading = false
            self.showFileViewer = false
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                // Save the image to the Files app
                print("Success download file")
                self.checkKnowledgeNavigatorBadge()
            }
        }
    }
    
    func updateLibrary(communityID: String) {
        
        db.collection("communities").document(communityID).collection("libraries").getDocuments { snapshot, error in
            
            guard let documents = snapshot?.documents else {
                print("Error fetching data \(String(describing: error))")
                self.isEmpty = true
                return
            }
            
            if documents.isEmpty {
                self.isEmpty = true
                return
            }
            
            for doc in documents {
                let id = doc.documentID
                let url = doc["url"] as! String
                let date = doc["dateCreated"] as! Timestamp
                let type = doc["type"] as! String
                let user = doc["user"] as! String
                self.isEmpty = false
                self.libraries.append(Library(id: id, url: url, dateCreated: date.dateValue(), type: type, user: user))
            }
        }
    }
    
    func deleteLibrary(indexSet: IndexSet, communityID: String) {
        // Convert indexSet to an array of indices
        let indicesToDelete = Array(indexSet)
        
        // Perform deletion operation here using the indicesToDelete array
        for index in indicesToDelete {
            let item = self.libraries[index]
            let starsRef = storageRef.child(item.url)
            
            // Delete the file in storage
            starsRef.delete { error in
                if let error = error {
                    print("Error deleting file:", error)
                } else {
                    // Delete the item from your data source
                    self.libraries.remove(at: index)
                }
            }
            
            // delete the data in firestore
            db.collection("communities").document(communityID).collection("libraries").document(item.id).delete() { err in
                if let err = err {
                    print("Error removing document: \(err)")
                } else {
                    print("Document successfully removed!")
                }
            }
        }
    }
    
    func refreshLibrary(communityID: String) {
        self.libraries.removeAll()
        self.isEmpty = false
        self.updateLibrary(communityID: communityID)
    }
    
    
    func uploadLibraryToFirebase(url: URL, communityID: String) {
        isLoading = true
        
        let date = dateFormatting()
        let filePath = "\(date)-\(url.lastPathComponent)"
        storageRef.child("libraries").child(filePath).putFile(from: url, metadata: nil) { metadata, error in
            self.isLoading = false
            if let error = error {
                print("Error uploading file to Firebase Storage: \(error.localizedDescription)")
            } else {
                print("File uploaded successfully.")
                self.uploadLibraryToFirestore(filePath: filePath, communityID: communityID)
                self.bm.validateBadge(badgeId: self.bm.getBadgeID(badgeName: "Research Guru")) { hasBadge in
                    if !hasBadge {
                        self.checkResearchGuruBadge()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
                }
                // Handle success case here
            }
        }
    }
    
    
    func uploadLibraryToFirestore(filePath: String, communityID: String) {
        let id = UUID().uuidString
        let path = "libraries/\(filePath)"
        
        let type = URL(filePath: path).pathExtension
        let newFile = Library(id: id, url: path, dateCreated: Date(), type: String(type), user: Auth.auth().currentUser?.uid ?? "")
        db.collection("communities").document(communityID).collection("libraries").document(id).setData([
            "url" : newFile.url,
            "dateCreated" : Timestamp(date: newFile.dateCreated),
            "type" : newFile.type,
            "user" : newFile.user
        ])
        libraries.append(newFile)
    }
    
    
    func dateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyyHHmmss"//"EE" to get short style
        let mydt = dateFormatter.string(from: date).capitalized

        return "\(mydt)"
    }
    
    // achieved when download file for the first time
    func checkKnowledgeNavigatorBadge() {
        let knowledgeNavigatorBadgeID = self.bm.getBadgeID(badgeName: "Knowledge Navigator")
        self.bm.validateBadge(badgeId: knowledgeNavigatorBadgeID) { hasBadge in
            if !hasBadge {
                self.bm.achieveBadge(badgeId: knowledgeNavigatorBadgeID)
            }
        }
        bm.getBadge(id: knowledgeNavigatorBadgeID) { badge in
            self.badgeImageURL = badge?.name ?? ""
            self.showAchievedBadge = true
        }
    }
    
    func isSameDayAsCurrentDate(date: Date) -> Bool {
        let calendar = Calendar.current
        
        let currentDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        return currentDateComponents == dateComponents
    }
    
    var filteredLibraries: [Library] {
        let user = Auth.auth().currentUser?.uid
        return libraries.filter { $0.user == user }
    }

    // achieved when upload 5 file in same day
    func checkResearchGuruBadge() {
        let userLibraries = filteredLibraries
        
        let currentDayUserLibraries = userLibraries.filter { isSameDayAsCurrentDate(date: $0.dateCreated) }
        
        if currentDayUserLibraries.count == 5 {
            let researchGuruBadgeID = bm.getBadgeID(badgeName: "Research Guru")
            bm.getBadge(id: researchGuruBadgeID) { badge in
                self.badgeImageURL = badge!.name
                self.showAchievedBadge = true
            }
            bm.achieveBadge(badgeId: researchGuruBadgeID)
        } else {
            showAchievedBadge = false
        }
        
    }

}
