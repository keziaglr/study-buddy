//
//  ProfileViewModel.swift
//  studybuddy
//
//  Created by Kezia Gloria on 29/06/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseStorage
import FirebaseFirestoreSwift
import Firebase

class ProfileViewModel: ObservableObject {
    let db = Firestore.firestore()
    let storageRef = Storage.storage().reference()
    @State var um = UserViewModel()
    
    func dateFormatting() -> String {
        let date = Date()
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"//"EE" to get short style
        let mydt = dateFormatter.string(from: date).capitalized

        return "\(mydt)"
    }
    
    func uploadProfilePictureToFirebase(url: URL) {
        let date = dateFormatting()
        let filePath = "\(date)-\(url.lastPathComponent)"
        storageRef.child("users").child(filePath).putFile(from: url, metadata: nil) { metadata, error in
            if let error = error {
                print("Error uploading file to Firebase Storage: \(error.localizedDescription)")
            } else {
                print("File uploaded successfully.")
                
                self.storageRef.child("users/\(filePath)").downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error.localizedDescription)")
                    } else if let downloadURL = url {
                        // Handle the download URL here
                        print("Download URL: \(downloadURL.absoluteString)")
                        
                        self.uploadProfilePictureToFirestore(filePath: downloadURL.absoluteString)
                        
                    }
                }
            }
        }
    }
    
    func uploadProfilePictureToFirestore(filePath: String) {
        
        um.getUser(id: Auth.auth().currentUser?.uid ?? "") { user in
            
            let prevUrl = user?.image
            self.db.collection("users").document(Auth.auth().currentUser!.uid).updateData(["image" : filePath])
            NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
            
            if prevUrl != "https://firebasestorage.googleapis.com/v0/b/mc2-studybuddy.appspot.com/o/users%2Fuser.png?alt=media&token=263b2e43-e206-45d6-a75f-7f7170063e41"{
                if let previousImageURL = URL(string: prevUrl ?? "") {
                    let previousImageRef = Storage.storage().reference(forURL: previousImageURL.absoluteString)
                    previousImageRef.delete { error in
                        if let error = error {
                            print("Error deleting previous image: \(error.localizedDescription)")
                        } else {
                            print("Previous image deleted successfully.")
                        }
                    }
                }
            }
        }
    }
}
