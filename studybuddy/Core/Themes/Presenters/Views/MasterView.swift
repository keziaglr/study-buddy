//
//  MasterView.swift
//  studybuddy
//
//  Created by Kezia Gloria on 27/06/23.
//

import SwiftUI
import Foundation
import Firebase

struct MasterView: View {
    @StateObject var vm = AuthenticationViewModel()
    @AppStorage("isDarkMode") private var isDarkMode = false
    var body: some View {
        //TODO: Fix navigation
        if Auth.auth().currentUser == nil {
            OnboardingPageView()
                .environmentObject(vm)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        } else if vm.created == true {
            InterestPageView()
                .environmentObject(vm)
                .preferredColorScheme(isDarkMode ? .dark : .light)
        } else {
            NavigationStack{
                TabBarNavigation()
            }
            .environmentObject(vm)
            .preferredColorScheme(isDarkMode ? .dark : .light)
        }
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
