//
//  FileViewerView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 28/06/23.
//

import SwiftUI

struct FileViewerView: View {
    @EnvironmentObject var vm: LibraryViewModel
    var body: some View {
        ZStack {
            WebView(fileURL: self.vm.selectedFileURL!)
                .offset(y: 70)
            VStack() {
                HStack(alignment: .center) {
                    Spacer()
                    Button{
                        self.vm.showFileViewer.toggle()
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
                        self.vm.downloadLibrary()
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
            
            if self.vm.showLoader() {
                LoaderView()
            }
        }
    }
}

struct FileViewerView_Previews: PreviewProvider {
    static var previews: some View {
        FileViewerView()
            .environmentObject(LibraryViewModel())
    }
}
