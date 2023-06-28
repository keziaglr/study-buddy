//
//  DocumentCellView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 27/06/23.
//

import SwiftUI
import UniformTypeIdentifiers
struct DocumentCellView: View {
    var data: Library
    var body: some View {
        HStack(spacing: 15) {
            Image(getImageName(dataType: data.type))
                .resizable()
                .renderingMode(.original)
                .scaledToFit()
                .frame(width: 50)
            
            VStack(alignment: .leading) {
                Text(getDataName(dataUrl: data.url))
                    .fontWeight(.bold)
                    .font(.system(size: 18))
                Text(data.dateCreated.formatted(date: .numeric, time: .omitted))
                    .font(.system(size: 15, weight: .light))
                    .italic()
            }
            
            Spacer()
        }
        .background(.white)
        .cornerRadius(10)
        .frame(maxHeight: 90)
    }
    
    func getImageName(dataType: String) -> String {
        if dataType == "doc" || dataType == "docx" {
            return "doc"
        }
        else if dataType == "ppt" || dataType == "pptx" {
            return "ppt"
        }
        else if dataType == "xls" || dataType == "xlsx" {
            return "xls"
        }
        else if isImageFileExtension(dataType) {
            return "image"
        }
        else if isAudioFileExtension(dataType) {
            return "audio"
        }
        else if isVideoFileExtension(dataType) {
            return "video"
        }
        else if isTextFileExtension(dataType) {
            return "text"
        }
        return dataType
    }
    
    func isAudioFileExtension(_ fileExtension: String) -> Bool {
        let imageUTType = UTType.audio
        guard let uti = UTType(filenameExtension: fileExtension) else {
            return false // Invalid file extension
        }
        return uti.conforms(to: imageUTType)
    }
    func isVideoFileExtension(_ fileExtension: String) -> Bool {
        let imageUTType = UTType.video
        guard let uti = UTType(filenameExtension: fileExtension) else {
            return false // Invalid file extension
        }
        return uti.conforms(to: imageUTType)
    }
    func isTextFileExtension(_ fileExtension: String) -> Bool {
        let imageUTType = UTType.text
        guard let uti = UTType(filenameExtension: fileExtension) else {
            return false // Invalid file extension
        }
        return uti.conforms(to: imageUTType)
    }
    func isImageFileExtension(_ fileExtension: String) -> Bool {
        let imageUTType = UTType.image
        guard let uti = UTType(filenameExtension: fileExtension) else {
            return false // Invalid file extension
        }
        return uti.conforms(to: imageUTType)
    }
    
    func getDataName(dataUrl: String) -> String {
        let url = URL(filePath: dataUrl)
        let name = url.lastPathComponent
        return name
    }
}

struct DocumentCellView_Previews: PreviewProvider {
    static var previews: some View {
        DocumentCellView(data: Library(id: UUID().uuidString, url: "TEST", dateCreated: Date(), type: "image"))
    }
}
