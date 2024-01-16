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
    var body: some View {
        ZStack{
            if Auth.auth().currentUser == nil {
                OnboardingPageView()
            } else {
                TabBarNavigation()
            }
        }
        .navigationBarBackButtonHidden()
    }
}

struct MasterView_Previews: PreviewProvider {
    static var previews: some View {
        MasterView()
    }
}
