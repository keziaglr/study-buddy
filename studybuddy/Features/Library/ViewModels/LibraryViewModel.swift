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
    @Published var showAchievedResearchGuruBadge = false
    @Published private var bm = BadgeViewModel()
    @Published private var um = UserViewModel()
    
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
            if let error = error {
                print("Error downloading image: \(error.localizedDescription)")
            } else {
                // Save the image to the Files app
                print("Success download file")
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
                self.bm.validateBadge(badgeId: self.getResearchGuruBadgeID()) { hasBadge in
                    if !hasBadge {
                        self.checkResearchGuruBadge()
                    }
                }
                // Handle success case here
            }
        }
    }
    
    func isSameDayAsCurrentDate(date: Date) -> Bool {
        let calendar = Calendar.current
        
        let currentDateComponents = calendar.dateComponents([.day, .month, .year], from: Date())
        let dateComponents = calendar.dateComponents([.day, .month, .year], from: date)
        
        return currentDateComponents == dateComponents
    }

    
    func checkResearchGuruBadge() {
        let userLibraries = libraries.filter { $0.user == Auth.auth().currentUser?.uid }
        
        let currentDayUserLibraries = userLibraries.filter { isSameDayAsCurrentDate(date: $0.dateCreated) }
        
        if currentDayUserLibraries.count == 5 {
            showAchievedResearchGuruBadge = true
        } else {
            showAchievedResearchGuruBadge = false
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
        NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
    }
    
    
    func dateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"//"EE" to get short style
        let mydt = dateFormatter.string(from: date).capitalized

        return "\(mydt)"
    }
    
    
    func getResearchGuruBadgeID() -> String {
        let scholarSupreme = bm.badges.first { badge in
            badge.name == "Research Guru"
        }
        return scholarSupreme!.id
    }

}
