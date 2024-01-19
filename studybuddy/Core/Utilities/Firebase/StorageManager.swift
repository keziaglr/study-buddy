//
//  StorageManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 15/01/24.
//

import Foundation
import FirebaseStorage
final class StorageManager {
    static let shared = StorageManager()
    private init() { }
    
    private let storage = Storage.storage().reference()
    
    private var userReference: StorageReference {
        storage.child("users")
    }
    
    private var communityReference: StorageReference {
        storage.child("communities")
    }
    private var libraryReference: StorageReference {
        storage
    }
    
    func saveCommunityImage(url: URL) async throws -> URL {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let imageName = "\(UUID().uuidString).jpeg"
        let imagePath = communityReference.child(imageName)
        
        do {
            let imageData = try Data(contentsOf: url)
            // Upload image data to Firebase Storage
            _ = try await imagePath.putDataAsync(imageData, metadata: meta)
            
            // Fetch the download URL for the uploaded image
            let downloadURL = try await imagePath.downloadURL()
            
            // Return the download URL
            return downloadURL
        } catch {
            throw error
        }
    }
    
    func saveUserProfileImage(url: URL) async throws -> URL {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let imageName = "\(UUID().uuidString).jpeg"
        let imagePath = userReference.child(imageName)
        
        do {
            let imageData = try Data(contentsOf: url)
            // Upload image data to Firebase Storage
            _ = try await imagePath.putDataAsync(imageData, metadata: meta)
            
            // Fetch the download URL for the uploaded image
            let downloadURL = try await imagePath.downloadURL()
            
            // Return the download URL
            return downloadURL
        } catch {
            throw error
        }
    }
    
    func deleteUserProfileImage(downloadURL: String) {
        // Parse the download URL to get the reference to the storage
        let storageRef = Storage.storage().reference(forURL: downloadURL)
        
        storageRef.delete { error in
            if let error  = error {
                print("Error deleting image: \(error.localizedDescription)")
            } else {
                print("Image deleted successfully")
                // You may want to update your UI or perform other actions after successful deletion
            }
        }
    }
    
    func uploadLibraryToCloudStorage(url: URL, filePath: String, communityID: String) async throws {
        let path = "libraries/\(filePath)"
        _ = try await libraryReference.child(path).putFileAsync(from: url, metadata: nil)
    }
    
    func deleteLibrary(filePath: String) {
        let fileRef = libraryReference.child(filePath)
        // Delete the file in storage
        fileRef.delete { error in
            if let error = error {
                print("Error deleting file:", error)
            } else {
                // Delete the item from your data source
                print("File deleted successfully")
            }
        }
    }
    
    func getFileDownloadURL(filePath: String) async throws -> URL {
        let fileRef = libraryReference.child(filePath)
        
        let downloadURL = try await fileRef.downloadURL()
        return downloadURL
    }
    
    
    func saveToLocal(localURL: URL, filePathInCloudStorage: String) async throws{
        let fileRef = libraryReference.child(filePathInCloudStorage)
        // Download the image from Firebase Storage
        _ = try await fileRef.writeAsync(toFile: localURL)
    }
}
