//
//  LibraryManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 19/01/24.
//

import Firebase
import FirebaseFirestore
import FirebaseFirestoreSwift

final class LibraryManager {
    static let shared = LibraryManager()
    
    func fileRef(communityID: String) -> CollectionReference {
        return Firestore.firestore().collection("communities").document(communityID).collection("libraries")
    }
    
    func addLibrary(file: Library, communityID: String) {
        do {
            try fileRef(communityID: communityID).document().setData(from: file)
        } catch {
            print(error)
        }
    }
    
    func getLibraries(communityID: String) async throws -> [Library] {
        var libraries: [Library] = []
        let snapshot = try await fileRef(communityID: communityID).getDocuments()
        for document in snapshot.documents {
            let file = try document.data(as: Library.self)
            libraries.append(file)
        }
        return libraries
    }
    
    func deleteLibrary(communityID: String, libraryID: String) {
        fileRef(communityID: communityID).document(libraryID).delete { error in
            if let err = error {
                print("Error removing document: \(err)")
            } else {
                print("Document successfully removed!")
            }
        }
    }
    

}
