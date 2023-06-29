//
//  DocumentPicker.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 26/06/23.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

struct DocumentPickerView: UIViewControllerRepresentable {
    var onFilePicked: (URL) -> Void
    
    func makeUIViewController(context: Context) -> UIDocumentPickerViewController {
        let docxType = UTType(tag: "docx", tagClass: .filenameExtension, conformingTo: nil)!
        let docType = UTType(tag: "doc", tagClass: .filenameExtension, conformingTo: nil)!
        let pdfType = UTType(tag: "pdf", tagClass: .filenameExtension, conformingTo: nil)!
        let xlsType = UTType(tag: "xls", tagClass: .filenameExtension, conformingTo: nil)!
        let xlsxType = UTType(tag: "xlsx", tagClass: .filenameExtension, conformingTo: nil)!
        let pptType = UTType(tag: "ppt", tagClass: .filenameExtension, conformingTo: nil)!
        let pptxType = UTType(tag: "pptx", tagClass: .filenameExtension, conformingTo: nil)!
        
        let supportedTypes: [UTType] = [UTType.audio, UTType.image, docxType ,docType, pdfType, xlsType, xlsxType, pptType, pptxType, UTType.text, UTType.video]
        let documentPicker = UIDocumentPickerViewController(forOpeningContentTypes: supportedTypes, asCopy: true)
        documentPicker.allowsMultipleSelection = false
        documentPicker.delegate = context.coordinator
        return documentPicker
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIDocumentPickerDelegate {
        var parent: DocumentPickerView
        
        init(_ parent: DocumentPickerView) {
            self.parent = parent
        }
        
        func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
            guard let url = urls.first else { return }
            self.parent.onFilePicked(url)
        }
        
        func documentPickerWasCancelled(_ controller: UIDocumentPickerViewController) {
            // Handle cancellation if needed
        }
    }
}
