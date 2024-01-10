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
    @State private var um = UserViewModel()
    @State private var user: UserModel? = nil
    @State var logout = false
    @State var showPicker = false
    @State var vm = ProfileViewModel()
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image("profile_gradient")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                        
                    
                    VStack {
                        //profile image
                        ZStack {
                            AsyncImage(url: URL(string: user?.image ?? "")) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 85, height: 85)
                                    .cornerRadius(15)
                                    .padding(.bottom, 14)
                            } placeholder: {
                            Image("user")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 85, height: 85)
                                    .cornerRadius(15)
                                    .padding(.bottom, 14)
                            }
                            
                            Button {
                                showPicker = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill()
                                        .foregroundColor(Color("Orange"))
                                        .frame(width: 25)
                                    Image(systemName: "pencil")
                                        .foregroundColor(.white)
                                }
                            }.offset(x: 35, y: 30)

                        }
                        
                        //name
                        Text(user?.name ?? "")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundColor(.white)
                            .padding(.bottom, 2)
                        
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
                    }.padding(.top, 30)
                }
                .edgesIgnoringSafeArea(.all)
                Spacer()
            }
            .onChange(of: showPicker, perform: { newValue in
                um.getUser(id: Auth.auth().currentUser?.uid ?? "mxVB7MT39gahu7hQ2ddsSDhOqNl1") { retrievedUser in
                    self.user = retrievedUser
                }
            })
            .task {
                um.getUser(id: Auth.auth().currentUser?.uid ?? "mxVB7MT39gahu7hQ2ddsSDhOqNl1") { retrievedUser in
                    self.user = retrievedUser
                }
                
        }
        }.navigationDestination(isPresented: $logout) {
            MasterView()
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showPicker) {
            ImagePicker(show: $showPicker) { url in
                self.vm.uploadProfilePictureToFirebase(url: url)
            }
        }
    }
}


struct ProfileHeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderComponent()
    }
}
