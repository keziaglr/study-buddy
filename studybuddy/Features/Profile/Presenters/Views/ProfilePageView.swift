//
//  ProfilePageView.swift
//  mini2
//
//  Created by Randy Julian on 24/06/23.
//

import SwiftUI

struct ProfilePageView: View {
    @EnvironmentObject var authVM: AuthenticationViewModel
    var body: some View {
        VStack{
            ProfileHeaderComponent()
                .environmentObject(authVM)
            BadgeView()
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
