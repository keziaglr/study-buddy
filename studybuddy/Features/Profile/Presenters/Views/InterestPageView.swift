//
//  InterestPageView.swift
//  studybuddy
//
//  Created by Randy Julian on 29/06/23.
//

import SwiftUI
import FirebaseFirestore
import FirebaseFirestoreSwift
import FirebaseAuth

struct InterestPageView: View {
    @State private var selectedPills: Set<String> = []
    @State private var uvm = UserViewModel()
    @State private var showHome = false

    var body: some View {

        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    HeaderComponent(text: "Hello! 👋🏼")
                    
                    HStack {
                        Text("What community are you looking today?")
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .frame(maxWidth: 284, alignment: .topLeading)
                            .position(x: geometry.size.width / 2.1, y: geometry.size.height * 0.27)
                    }
                    
                    PillsButtonComponent(selectedPills: $selectedPills)
                        .frame(maxHeight: geometry.size.height/1.92)
                        .position(x: geometry.size.width / 1.75, y: geometry.size.height * 0.61)
                    
                    Button(action: {
                        showHome = true
                    }) {
                        CustomButton(text: "Continue")
                    }
                    .opacity(selectedPills.isEmpty ? 0.5 : 1.0)
                    .disabled(selectedPills.isEmpty)
                    .position(x: geometry.size.width/2 , y: geometry.size.height * 0.900)
                    
                }
            }.navigationDestination(isPresented: $showHome) {
                TabBarNavigation()
            }
        }.navigationBarBackButtonHidden()
    }
}

struct InterestPageView_Previews: PreviewProvider {
    static var previews: some View {
        InterestPageView()
    }
}