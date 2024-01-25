//
//  LibraryView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 26/06/23.
//

import SwiftUI
import UniformTypeIdentifiers

struct LibraryView: View {
    @StateObject var libraryViewModel = LibraryViewModel()
    var communityID: String
    @State var showImagePicker = false
    @State var showDocPicker = false
    @State var showFileDetail = false
    @Environment(\.presentationMode) var presentationMode
    var body: some View {
        ZStack {
            Color.black.opacity(0.05).edgesIgnoringSafeArea(.bottom)
            ZStack(alignment: .bottomTrailing) {
                if self.libraryViewModel.libraries.count != 0 {
                    List {
                        ForEach(self.libraryViewModel.libraries) {library in
                            Button {
                                viewFile(library: library)
                            } label: {
                                DocumentCellComponent(data: library)
                            }
                            .padding(.vertical, 10)
                            .listRowSeparator(.hidden)
                        }
                        .onDelete { indexSet in
                            self.libraryViewModel.deleteLibrary(indexSet: indexSet, communityID: communityID)
                        }
                    }
                }
                
                if self.libraryViewModel.libraries.isEmpty {
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
            
            LoaderComponent(isLoading: $libraryViewModel.isLoading)
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
                    if self.libraryViewModel.libraries.count != 0 && !self.libraryViewModel.isLoading{
                        Button {
                            self.libraryViewModel.refreshLibrary(communityID: communityID)
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
                            self.showDocPicker.toggle()
                        } label: {
                            Label("Add Document", systemImage: "doc")
                        }
                        Button{
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
        
        .sheet(isPresented: $showDocPicker, content: {
            DocumentPickerView(onFilePicked: { url in
                self.libraryViewModel.uploadLibraryToFirebase(url: url, communityID: communityID)
            })
            .edgesIgnoringSafeArea(.all)
            
        })
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(show: $showImagePicker) { url in
                self.libraryViewModel.uploadLibraryToFirebase(url: url, communityID: communityID)
                
            }
            .edgesIgnoringSafeArea(.all)
        }
        .sheet(isPresented: $showFileDetail, content: {
            FileViewerView(showFileDetail: $showFileDetail)
                .environmentObject(libraryViewModel)
                .edgesIgnoringSafeArea(.all)
        })
        .onAppear {
            self.libraryViewModel.updateLibrary(communityID: self.communityID)
        }
        .sheet(isPresented: $libraryViewModel.showBadge) {
            if showFileDetail == false {
                BadgeEarnedView(badge: libraryViewModel.showedBadge)
                    .edgesIgnoringSafeArea(.all)
            }
        }
    }
    
    func viewFile(library: Library) {
        Task {
            do {
                try await libraryViewModel.getFileDetail(library: library)
            } catch {
                print(error)
            }
            showFileDetail = true
        }
    }
    
}




struct LibraryView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            LibraryView(communityID: Community.previewDummy.id!)
        }
    }
}
