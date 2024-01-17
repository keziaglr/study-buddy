//
//  MasterView.swift
//  studybuddy
//
//  Created by Kezia Gloria on 27/06/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

struct MasterView: View {
    @StateObject var vm = AuthenticationViewModel()
    var body: some View {
        //TODO: Fix navigation
        if Auth.auth().currentUser == nil {
            OnboardingPageView()
                .environmentObject(vm)
        } else {
            TabBarNavigation()
                .environmentObject(vm)
        }
//        .navigationBarBackButtonHidden()
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
