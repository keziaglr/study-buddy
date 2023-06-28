//
//  LibraryNavBarComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 27/06/23.
//

import SwiftUI

struct LibraryNavBarComponent: View {
    var body: some View {
        GeometryReader { geometry in
            VStack(spacing: -1){
                // Info Bar
                HStack(alignment: .center){
                    // Back Button
                    Button {
                        print("tap")
                    } label: {
                        Image(systemName: "chevron.backward.circle")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 30, height: 30)
                            .padding(EdgeInsets(top: 10, leading: 10, bottom: 10, trailing: 0))
                    }

                    Spacer()

                    // Title
                    Text("Library")
                        .fontWeight(.bold)
                        .font(.system(size: 21))
                        .foregroundColor(.white)
                        .padding(.vertical)
//                        .position(x: 10, y: 10)


                    Spacer()

                    // Refresh Button
                    Button {
                        print("tap")
                    } label: {
                        Image(systemName: "goforward")
                            .resizable()
                            .bold()
                            .foregroundColor(Color.white)
                            .frame(width: 23, height: 25)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 0))
                    }

                    // Add Button
                    Button {
                        print("tap")
                    } label: {
                        Image(systemName: "plus")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 23, height: 25)
                            .padding(EdgeInsets(top: 10, leading: 0, bottom: 10, trailing: 10))
                    }
                }
                .background(Color("DarkBlue"))
            }
//            .ignoresSafeArea()
        }
    }
}



struct LibraryNavBarComponent_Previews: PreviewProvider {
    static var previews: some View {
        LibraryNavBarComponent()
    }
}
