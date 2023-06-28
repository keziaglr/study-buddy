//
//  ProfilePageView.swift
//  mini2
//
//  Created by Randy Julian on 23/06/23.
//

import SwiftUI
import Foundation
import FirebaseFirestore
import FirebaseFirestoreSwift
import Firebase

struct ProfileHeaderComponent: View {
    @State private var um = UserManager()
    @State private var user: UserModel? = nil
    @State var logout = false
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image("profile_gradient")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                    
                    VStack {
                        HStack{
                            Button(action: {
                                //add action
                            }) {
                                Image(systemName: "chevron.backward.circle")
                                    .font(.system(size: 24))
                                    .padding(EdgeInsets(top: -20, leading: 17, bottom: 0, trailing: 0))
                                    .foregroundColor(.white)
                                Spacer()
                            }
                        }
                        
                        //profile image
                        AsyncImage(url: URL(string: user?.image ?? "")) { image in
                            image
                                .resizable()
                                .scaledToFit()
                                .frame(width: 85, height: 85)
                                .cornerRadius(15)
                                .padding(.bottom, 14)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        //name
                        Text(user?.name ?? "")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.bottom, 14)
                        
                        //year joined
                        Text(user?.email ?? "")
                            .fontWeight(.light)
                            .font(.system(size: 14))
                            .foregroundColor(.white)
                            .padding(.bottom, 14)
                        VStack{
                            Button(action: {
                                //add action
                                logout = true
                                let firebaseAuth = Auth.auth()
                                do {
                                  try firebaseAuth.signOut()
                                } catch let signOutError as NSError {
                                  print("Error signing out: %@", signOutError)
                                }
                            }) {
                                Text("Logout")
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .font(.system(size: 19))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .background(Color("Orange"))
                                    .cornerRadius(10)
                            }
                        }
                    }
                }
                .edgesIgnoringSafeArea(.all)
                Spacer()
            }.task {
                um.getUser(id: Auth.auth().currentUser?.uid ?? "") { retrievedUser in
                    self.user = retrievedUser
                }
        }
        }.navigationDestination(isPresented: $logout) {
            MasterView()
        }
    }
}


struct ProfileHeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderComponent()
    }
}
