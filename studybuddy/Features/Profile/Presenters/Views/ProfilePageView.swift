//
//  ProfilePageView.swift
//  mini2
//
//  Created by Randy Julian on 24/06/23.
//

import SwiftUI

struct ProfilePageView: View {
    @State var isLoading = false
    var body: some View {
        ZStack {
            VStack{
                ProfileHeaderComponent(isLoading: $isLoading)
                BadgeView()
            }
            LoaderComponent(isLoading: $isLoading)
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
