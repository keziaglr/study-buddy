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

@MainActor
class LibraryViewModel: ObservableObject {
    @Published var libraries = [Library]()
    @Published var isLoading = false
    @Published var showFileViewer = false
    @Published var selectedFileURL: URL? = nil
    @Published var selectedFilePathForDownload: String? = nil
    @Published var showBadge = false
    @Published var showedBadge: Badge?
    var badgeManager = BadgeManager.shared
    
    func showLoader() -> Bool {
        return self.isLoading || (self.libraries.count == 0)
    }
    
    func getFileDetail(library: Library) async throws {
        isLoading = true
        
        let downloadURL = try await StorageManager.shared.getFileDownloadURL(filePath: library.url)
        selectedFileURL = downloadURL.absoluteURL
        selectedFilePathForDownload = library.url
        isLoading = false
    }
    
    func downloadLibrary() async throws {
        self.isLoading = true
        let fileManager = FileManager.default
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        
        let fileName = URL(filePath: self.selectedFilePathForDownload!).lastPathComponent
        let localURL = documentsURL.appendingPathComponent(fileName)
        
        try await StorageManager.shared.saveToLocal(localURL: localURL, filePathInCloudStorage: self.selectedFilePathForDownload!)
        
        self.isLoading = false
    }
    
    func updateLibrary(communityID: String) {
        isLoading = true
        Task {
            do {
                libraries = try await LibraryManager.shared.getLibraries(communityID:communityID)
            } catch {
                print(error)
            }
            isLoading = false
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
        self.updateLibrary(communityID: communityID)
    }
    
    
    func uploadLibraryToFirebase(url: URL, communityID: String) {
        isLoading = true
        
        let date = Date().dateFormat()
        let filePath = "\(date)-\(url.lastPathComponent)"
        Task {
            do {
                try await StorageManager.shared.uploadLibraryToCloudStorage(url: url, filePath: filePath, communityID: communityID)
                uploadLibraryToFirestore(filePath: filePath, communityID: communityID)
                showBadge = try await checkResearchGuruBadge()
                refreshLibrary(communityID: communityID)
            } catch {
                print(error)
            }
            isLoading = false
        }
    }
    
    
    func uploadLibraryToFirestore(filePath: String, communityID: String) {
        let path = "libraries/\(filePath)"
        
        let type = URL(filePath: path).pathExtension
        let newFile = Library(url: path, dateCreated: Date(), type: String(type), user: Auth.auth().currentUser?.uid ?? "")
        LibraryManager.shared.addLibrary(file: newFile, communityID: communityID)
        
        libraries.append(newFile)
        
    }
    
    // achieved when download file for the first time
    func checkKnowledgeNavigatorBadge() async throws -> Bool{
//        let knowledgeNavigatorBadgeID = badgeManager.getBadgeID(badgeName: Badges.knowledgeNavigator)
        if badgeManager.validateBadge(badgeName: Badges.knowledgeNavigator) == false {
            try await badgeManager.achieveBadge(badgeName: Badges.knowledgeNavigator)
            let badge = badgeManager.getBadge(badgeName: Badges.knowledgeNavigator)
            showedBadge = badge
            return true
        }
        return false
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
    func checkResearchGuruBadge() async throws -> Bool{
        if badgeManager.validateBadge(badgeName: Badges.researchGuru) == false {
            let userLibraries = filteredLibraries
            
            let currentDayUserLibraries = userLibraries.filter { isSameDayAsCurrentDate(date: $0.dateCreated) }
            
            if currentDayUserLibraries.count == 5 {
                let badgeName = Badges.researchGuru
                try await badgeManager.achieveBadge(badgeName: badgeName)
                let badge = badgeManager.getBadge(badgeName: badgeName)
                showedBadge = badge
                return true
            } else {
                return false
            }
        }
        return false
    }

}
