//
//  ProfilePageView.swift
//  mini2
//
//  Created by Randy Julian on 24/06/23.
//

import SwiftUI

struct ProfilePageView: View {
    @StateObject private var userViewModel = UserViewModel()
    var body: some View {
        NavigationStack {
            ZStack{
                ProfileHeaderComponent()
                    .environmentObject(userViewModel)
                BadgeView()
                    .environmentObject(userViewModel)
            }
            .task {
                do {
                    _ = try await userViewModel.getUserProfile()
                } catch {
                    print(error)
                }
            }
        }
    }
}

struct ProfilePageView_Previews: PreviewProvider {
    static var previews: some View {
        ProfilePageView()
    }
}
