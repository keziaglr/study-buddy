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
    var communityID: String
    @State var showImagePicker = false
    @State var showDocPicker = false
//    @State var showBadge = false
    @State var showFileDetail = false
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
                                    self.vm.getFileDetail(library: library)
                                    showFileDetail.toggle()
                                } label: {
                                    DocumentCellComponent(data: library)
                                }
                                .padding(.vertical, 10)
                                .listRowSeparator(.hidden)
                            }
                            .onDelete { indexSet in
                                self.vm.deleteLibrary(indexSet: indexSet, communityID: communityID)
                            }
                        }
                    }
                    
                    if self.vm.libraries.isEmpty {
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
                
//                if self.vm.showLoader() {
                    LoaderComponent(isLoading: $vm.isLoading)
//                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarBackButtonHidden()
            .toolbarBackground(
                            Colors.lightBlue,
                            for: .navigationBar)
                        .toolbarBackground(.visible, for: .navigationBar)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button{
                        print("Library back button clicked")
                        presentationMode.wrappedValue.dismiss()
                    } label: {
                        Image(systemName: "arrow.backward")
                            .resizable()
                            .scaledToFit()
                            .foregroundColor(Colors.black)
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
                                    .foregroundColor(Colors.black)
                            }
                        }
                        Menu{
                            Button {
//                                self.pickerType = "doc"
                                self.showDocPicker.toggle()
                            } label: {
                                Label("Add Document", systemImage: "doc")
                            }
                            Button{
//                                self.pickerType = "image"
                                self.showImagePicker.toggle()
                            } label: {
                                Label("Add Photo or Video", systemImage: "photo.on.rectangle")
                            }
                        } label: {
                            Image(systemName: "plus")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20)
                                .foregroundColor(Colors.black)
                        }
                        
                    }
                }
                ToolbarItem(placement: .principal) {
                    Text("Library")
                        .foregroundColor(Colors.black)
                        .kerning(0.45)
                        .bold()
                }
            }
            
        }
        .sheet(isPresented: $showDocPicker, content: {
            DocumentPickerView(onFilePicked: { url in
                self.vm.uploadLibraryToFirebase(url: url, communityID: communityID)
            })
            .edgesIgnoringSafeArea(.all) 
            
        })
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(show: $showImagePicker) { url in
                self.vm.uploadLibraryToFirebase(url: url, communityID: communityID)
                
            }
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $showFileDetail, content: {
            FileViewerView(showFileDetail: $showFileDetail)
                .environmentObject(vm)
                .edgesIgnoringSafeArea(.all)
        })
        .onAppear {
            self.vm.updateLibrary(communityID: self.communityID)
//            NotificationCenter.default.addObserver(forName: NSNotification.Name("Update"), object: nil, queue: .main) { _ in
//                self.vm.refreshLibrary(communityID: communityID)
//            }
        }
        .sheet(isPresented: $vm.showBadge) {
            BadgeEarnedView(image: vm.showedBadge)
                .edgesIgnoringSafeArea(.all)
        }
    }
    
    
}




struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        LibraryView(communityID: "SQdVEsc9RiT1Us2cDlEs")
    }
}
