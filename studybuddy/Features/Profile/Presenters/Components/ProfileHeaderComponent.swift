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
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(15)
                                    .padding(.bottom, 8)
                            } placeholder: {
                            Image("user")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(15)
                                    .padding(.top, 21)
                                    .padding(.bottom, 8)
                            }
                            
                            Button {
                                showPicker = true
                            } label: {
                                ZStack {
                                    Circle()
                                        .fill()
                                        .foregroundColor(Color("Orange"))
                                        .frame(width: 25)
                                        .fontWeight(.bold)
                                    Image(systemName: "pencil")
                                        .foregroundColor(.white)
                                }
                            }.offset(x: 35, y: 30)

                        }
                        
                        //name
                        Text(user?.name ?? "")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundColor(Color("Orange"))
                            .kerning(0.6)
//                            .padding(.bottom, 2)
                        
                        //email
                        Text(user?.email ?? "")
                            .fontWeight(.light)
                            .font(.system(size: 18))
                            .foregroundColor(Color("Orange"))
                            .padding(.bottom, 8)
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
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 7)
                                    .font(.system(size: 19))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .background(Color("Orange"))
                                    .cornerRadius(100)
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
