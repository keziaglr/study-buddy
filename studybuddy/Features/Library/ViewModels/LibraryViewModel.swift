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
//    @Published var isEmpty = false
    @Published var isLoading = false
    @Published var showFileViewer = false
    @Published var selectedFileURL: URL? = nil
    @Published var selectedFilePathForDownload: String? = nil
    @Published var showAchievedBadge = false
    @Published private var bvm = BadgeViewModel()
    @Published var badgeImageURL = ""
    
//    let db = Firestore.firestore()
//    let storageRef = Storage.storage().reference()
    
    func showLoader() -> Bool {
        return self.isLoading || (self.libraries.count == 0)
    }
    
    func showFileViewer(library: Library) {
        self.isLoading = true
        
        Task {
            do {
                let downloadURL = try await StorageManager.shared.getFileDownloadURL(filePath: library.url)
                selectedFileURL = downloadURL.absoluteURL
                selectedFilePathForDownload = library.url
                showFileViewer.toggle()
            } catch {
                print(error)
            }
            isLoading = false
        }
        // Fetch the download URL
//        starsRef.downloadURL { url, error in
//            self.isLoading = false
//            if let error = error {
//                print(error)
//                // Handle any errors
//            } else {
//                self.selectedFileURL = url?.absoluteURL
//                self.selectedFilePathForDownload = library.url
//                self.showFileViewer.toggle()
//            }
//        }
    }
    
    func downloadLibrary() {
        self.isLoading = true
//        let starsRef = storageRef.child(self.selectedFilePathForDownload!)

        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        
        let fileName = URL(filePath: self.selectedFilePathForDownload!).lastPathComponent
        let localURL = documentsURL.appendingPathComponent(fileName)
        
        Task {
            do {
                try await StorageManager.shared.saveToLocal(localURL: localURL, filePathInCloudStorage: self.selectedFilePathForDownload!)
            } catch {
                print(error)
            }
            self.isLoading = false
            self.checkKnowledgeNavigatorBadge()
        }
    }
    
//    func saveToLocal(localURL: URL, starsRef: StorageReference) {
//        // Download the image from Firebase Storage
//        starsRef.write(toFile: localURL) { url, error in
//            self.isLoading = false
//            self.showFileViewer = false
//            if let error = error {
//                print("Error downloading image: \(error.localizedDescription)")
//            } else {
//                // Save the image to the Files app
//                print("Success download file")
//                self.checkKnowledgeNavigatorBadge()
//            }
//        }
//    }
    
    func updateLibrary(communityID: String) {
        
//        db.collection("communities").document(communityID).collection("libraries").getDocuments { snapshot, error in
//            
//            guard let documents = snapshot?.documents else {
//                print("Error fetching data \(String(describing: error))")
//                self.isEmpty = true
//                return
//            }
//            
//            if documents.isEmpty {
//                self.isEmpty = true
//                return
//            }
//            
//            for doc in documents {
//                let id = doc.documentID
//                let url = doc["url"] as! String
//                let date = doc["dateCreated"] as! Timestamp
//                let type = doc["type"] as! String
//                let user = doc["user"] as! String
//                self.isEmpty = false
//                self.libraries.append(Library(id: id, url: url, dateCreated: date.dateValue(), type: type, user: user))
//            }
//        }
        Task {
            do {
                libraries = try await LibraryManager.shared.getLibraries(communityID:communityID)
            } catch {
                print(error)
            }
        }
    }
    
    func deleteLibrary(indexSet: IndexSet, communityID: String) {
        // Convert indexSet to an array of indices
        let indicesToDelete = Array(indexSet)
        
        // Perform deletion operation here using the indicesToDelete array
        for index in indicesToDelete {
            let item = self.libraries[index]
            StorageManager.shared.deleteLibrary(filePath: item.url)
            self.libraries.remove(at: index)
            
            // delete the data in firestore
            LibraryManager.shared.deleteLibrary(communityID: communityID, libraryID: item.id!)
        }
    }
    
    func refreshLibrary(communityID: String) {
        self.libraries.removeAll()
//        self.isEmpty = false
        self.updateLibrary(communityID: communityID)
    }
    
    
    func uploadLibraryToFirebase(url: URL, communityID: String) {
        isLoading = true
        
        let date = dateFormatting()
        let filePath = "\(date)-\(url.lastPathComponent)"
        Task {
            do {
                try await StorageManager.shared.uploadLibraryToCloudStorage(url: url, filePath: filePath, communityID: communityID)
                uploadLibraryToFirestore(filePath: filePath, communityID: communityID)
                self.bvm.validateBadge(badgeId: self.bvm.getBadgeID(badgeName: "Research Guru")) { hasBadge in
                    if !hasBadge {
                        self.checkResearchGuruBadge()
                    }
                    NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
                }
                isLoading = false
            } catch {
                print(error)
            }
        }
        
//        storageRef.child("libraries").child(filePath).putFile(from: url, metadata: nil) { metadata, error in
//            self.isLoading = false
//            if let error = error {
//                print("Error uploading file to Firebase Storage: \(error.localizedDescription)")
//            } else {
//                print("File uploaded successfully.")
//                self.uploadLibraryToFirestore(filePath: filePath, communityID: communityID)
//                self.bvm.validateBadge(badgeId: self.bvm.getBadgeID(badgeName: "Research Guru")) { hasBadge in
//                    if !hasBadge {
//                        self.checkResearchGuruBadge()
//                    }
//                    NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
//                }
//                // Handle success case here
//            }
//        }
    }
    
    
    func uploadLibraryToFirestore(filePath: String, communityID: String) {
        let path = "libraries/\(filePath)"
        
        let type = URL(filePath: path).pathExtension
        let newFile = Library(url: path, dateCreated: Date(), type: String(type), user: Auth.auth().currentUser?.uid ?? "")
        LibraryManager.shared.addLibrary(file: newFile, communityID: communityID)
        
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
        let knowledgeNavigatorBadgeID = self.bvm.getBadgeID(badgeName: "Knowledge Navigator")
        self.bvm.validateBadge(badgeId: knowledgeNavigatorBadgeID) { hasBadge in
            if !hasBadge {
                self.bvm.achieveBadge(badgeId: knowledgeNavigatorBadgeID)
            }
        }
        bvm.getBadge(id: knowledgeNavigatorBadgeID) { badge in
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
            let researchGuruBadgeID = bvm.getBadgeID(badgeName: "Research Guru")
            bvm.getBadge(id: researchGuruBadgeID) { badge in
                self.badgeImageURL = badge!.name
                self.showAchievedBadge = true
            }
            bvm.achieveBadge(badgeId: researchGuruBadgeID)
        } else {
            showAchievedBadge = false
        }
        
    }

}
