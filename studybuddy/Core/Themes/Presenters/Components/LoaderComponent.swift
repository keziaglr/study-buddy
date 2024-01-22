//
//  LoaderView.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 28/06/23.
//

import SwiftUI

struct LoaderComponent: View {
    @Binding var isLoading: Bool
    var body: some View {
        if isLoading {
            VStack{
                Spacer()
                HStack {
                    Spacer()
                    ProgressView()
                        .frame(width: 80, height: 80)
                        .background(Colors.white)
                        .cornerRadius(15)
                    Spacer()
                }
                Spacer()
            }
            .background(Colors.black.opacity(0.15).edgesIgnoringSafeArea(.all))
        }
    }
}

struct LoaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        LoaderComponent(isLoading: .constant(true))
    }
}
