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
//    @State var changePage = 1
    var body: some View {
        //TODO: Fix navigation
        ZStack{
            if Auth.auth().currentUser == nil {
//                if changePage == 1 {
//                    OnboardingPageView(changePage: $changePage)
//                }else if changePage == 2 {
//                    LoginPageView(changePage: $changePage)
//                        .environmentObject(authViewModel)
//                }else if changePage == 3 {
//                    RegisterPageView(changePage: $changePage)
//                        .environmentObject(authViewModel)
//                }
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
