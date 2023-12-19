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
//    @State private var user = UserModel(id: "", name: "", email: "", password: "", image: "", category: [], badges:[])
    var body: some View {

        NavigationStack {
            VStack {
                GeometryReader { geometry in
                    HeaderComponent(text: "Hello ")
                        .onAppear{
//                            uvm.getUser(id: Auth.auth().currentUser?.uid ?? "") { user in
//                                self.user = user!
//                            }
                        }
                    
                    HStack {
                        Text("Pick your interest : ")
                            .fontWeight(.medium)
                            .font(.system(size: 20))
                            .position(x: geometry.size.width / 3, y: geometry.size.height * 0.25)
                    }
                    
                    PillsButton(selectedPills: $selectedPills)
                        .frame(maxHeight: geometry.size.height/1.8)
                        .position(x: geometry.size.width / 1.75, y: geometry.size.height * 0.55)
                    
                    Button(action: {
                        //TODO: Insert to category
                        showHome = true
                    }) {
                        Text("CONTINUE")
                            .frame(width: 302, height: 40)
                            .font(.system(size: 18))
                            .bold()
                            .foregroundColor(.white)
                            .background(Color("Orange"))
                            .cornerRadius(10)
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

//struct InterestPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        InterestPageView()
//    }
//}
