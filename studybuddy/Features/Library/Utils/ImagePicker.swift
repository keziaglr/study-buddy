//
//  ImagePicker.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 26/06/23.
//

import Foundation
import UIKit
import SwiftUI
import Photos

struct ImagePicker: UIViewControllerRepresentable {
//    @Binding var isLoading: Bool
    @Binding var show: Bool
    var onFilePicked: (URL) -> Void
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .photoLibrary
        picker.delegate = context.coordinator
        return picker
    }
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {
        
    }
    func makeCoordinator() -> Coordinator {
        return ImagePicker.Coordinator(self)
    }
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            self.parent.show = false
        }
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
//            private func loadImageFromPicker(info: [UIImagePickerController.InfoKey : Any]) {
//                    guard let phAsset = info[.phAsset] as? PHAsset else {
//                        return
//                    }
//
//                    // size doesn't matter, because resizeMode = .none
//                    let size = CGSize(width: 32, height: 32)
//                    let options = PHImageRequestOptions()
//                    options.version = .original
//                    options.deliveryMode = .highQualityFormat
//                    options.resizeMode = .none
//                    options.isNetworkAccessAllowed = true
//                    PHImageManager.default().requestImage(for: phAsset, targetSize: size, contentMode: .aspectFit, options: options) { [weak self] (image, info) in
//                        if let s = self, let image = image {
//                            // use this image
//                        }
//                    }
//                }
            
            let url = info[.imageURL] as! URL
            self.parent.onFilePicked(url)
            self.parent.show = false
//            let storage = Storage.storage()
//            print("image url: \(url)")
//            storage.reference().child("Cloud Data").child("\(Date().timeIntervalSince1970)-\(url.lastPathComponent)").putFile(from: url, metadata: nil) { metadata, err in
//                if err != nil {
//                    print((err?.localizedDescription)!)
//                    return
//                }
//                NotificationCenter.default.post(name: NSNotification.Name("Update"), object: nil)
//                self.parent.isLoading = false
//            }
//            self.parent.isLoading = true
        }
    }
        
}


