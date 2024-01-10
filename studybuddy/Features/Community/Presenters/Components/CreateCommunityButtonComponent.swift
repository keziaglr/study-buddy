//
//  CreateCommunityButton.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 30/06/23.
//

import SwiftUI
struct CreateCommunityButtonComponent: View {
    @Binding var showModal: Bool
    
    var body: some View {
        VStack {
            Button(action: { showModal = true }) {
                CustomButton(text: "Create Community", primary: false)
            }
        }
        .padding(.top, 16)
    }
}
