//
//  LibraryView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 26/06/23.
//

import SwiftUI
import FirebaseStorage
import UniformTypeIdentifiers
import FirebaseFirestore

struct LibraryView: View {
    @StateObject var vm = LibraryViewModel()
    @Binding var communityID: String
    @State var showPicker = false
    @State var pickerType = ""
    
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        NavigationStack {
            ZStack {
                Color.black.opacity(0.05).edgesIgnoringSafeArea(.bottom)
                ZStack(alignment: .bottomTrailing) {
                    if self.vm.libraries.count != 0 {
                        List {
                            ForEach(self.vm.libraries) {library in
                                Button {
                                    self.vm.showFileViewer(library: library)
                                } label: {
                                    DocumentCellView(data: library)
                                }
                                .padding(.vertical, 10)
                                .listRowSeparator(.hidden)
                            }
                            .onDelete { indexSet in
                                self.vm.deleteLibrary(indexSet: indexSet, communityID: communityID)
                            }
                        }
                    }
                    
                    if self.vm.isEmpty {
                        GeometryReader {_ in
                            VStack {
                                Spacer()
                                HStack{
                                    Spacer()
                                    Text("Library is empty")
                                    Spacer()
                                }
                                Spacer()
                            }
                        }
                    }
                }
                
                if self.vm.showLoader() {
                    LoaderView()
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbarBackground(
                            Color("LightBlue"),
                            for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(.black)
                    }
                }
                ToolbarItem(placement: .navigationBarTrailing) {
                    HStack{
                        if self.vm.libraries.count != 0 && !self.vm.isLoading{
                            Button {
                                self.vm.refreshLibrary(communityID: communityID)
                            }label: {
                                Image(systemName: "arrow.clockwise")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 20)
                                    .foregroundColor(.black)
                            }
                        }
                        Menu{
                            Button {
                                self.pickerType = "doc"
                                self.showPicker.toggle()
                            } label: {
                                Label("Add Document", systemImage: "doc")
                            }
                            Button{
                                self.pickerType = "image"
                                self.showPicker.toggle()
                            } label: {
                                Label("Add Photo or Video", systemImage: "photo.on.rectangle")
                            }
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(.black)
                        }
                        
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Library")
                        .foregroundColor(.black)
                        .kerning(0.45)
                        .bold()
                }
            }
            
        }
        .sheet(isPresented: $showPicker) {
            if self.pickerType == "doc" {
                DocumentPickerView(onFilePicked: { url in
                    self.vm.uploadLibraryToFirebase(url: url, communityID: communityID)
                })
            } else {
                ImagePicker(show: $showPicker) { url in
                    self.vm.uploadLibraryToFirebase(url: url, communityID: communityID)
                }
            }
        }
        .sheet(isPresented: $vm.showFileViewer, content: {
            FileViewerView()
                .environmentObject(vm)
        })
        .onAppear {
            self.vm.updateLibrary(communityID: self.communityID)
            NotificationCenter.default.addObserver(forName: NSNotification.Name("Update"), object: nil, queue: .main) { _ in
                self.vm.refreshLibrary(communityID: communityID)
            }
        }
        .sheet(isPresented: $vm.showAchievedBadge) {
            BadgeEarnedView(image: vm.badgeImageURL)
        }
    }
    
    
}




struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(communityID: .constant("SQdVEsc9RiT1Us2cDlEs"))
    }
}
