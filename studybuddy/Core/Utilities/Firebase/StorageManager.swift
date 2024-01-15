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
    
    private var trashBinReference: StorageReference {
        storage.child("users")
    }
    
    func saveUserProfileImage(url: URL) async throws -> URL {
        let meta = StorageMetadata()
        meta.contentType = "image/jpeg"
        
        let imageName = "\(UUID().uuidString).jpeg"
        let imagePath = trashBinReference.child(imageName)
        
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
}
