//
//  FileViewerView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 28/06/23.
//

import SwiftUI

struct FileViewerView: View {
    @EnvironmentObject var vm: LibraryViewModel
    @Binding var showFileDetail: Bool
    var body: some View {
        ZStack {
            WebView(fileURL: self.vm.selectedFileURL!)
                .offset(y: 70)
            VStack() {
                HStack(alignment: .center) {
                    Spacer()
                    Button{
                        showFileDetail = false
                    } label: {
                        Text("Done")
                            .font(.headline)
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 18)
                .frame(height: 70)
                .background(.bar)
                Spacer()
                HStack(alignment: .center) {
                    ShareLink(item: self.vm.selectedFileURL!) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 22))
                    }
                    Spacer()
                    Button {
                        Task {
                            do {
                                try await self.vm.downloadLibrary()
                                let getBadge = try await vm.checkKnowledgeNavigatorBadge()
                                if getBadge == true {
                                    showFileDetail = false
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                                        vm.showBadge = true
                                    }
                                }
                            } catch {
                                print(error)
                            }
                        }
                        
                    } label: {
                        Image(systemName: "arrow.down.circle")
                            .font(.system(size: 22))
                            .foregroundColor(.blue)
                    }
                }
                .padding(.horizontal, 18)
                .padding(.bottom, 20)
                .frame(height: 70)
                .background(.bar.opacity(0.8))
            }
            .edgesIgnoringSafeArea(.all)
            
            LoaderComponent(isLoading: $vm.isLoading)
        }
    }
}

