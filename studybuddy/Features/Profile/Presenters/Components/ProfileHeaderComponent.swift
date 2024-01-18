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
import Kingfisher

struct ProfileHeaderComponent: View {
    @ObservedObject private var userViewModel = UserViewModel()
    @EnvironmentObject var authVM: AuthenticationViewModel
    //    @State private var user: UserModel? = nil
    @State var logout = false
    @State var showPicker = false
    @AppStorage("isDarkMode") private var isDarkMode = false
    
    var body: some View {
        NavigationStack {
            VStack {
                ZStack {
                    Image("profile_gradient")
                        .resizable()
                        .scaledToFit()
                        .ignoresSafeArea()
                    
                    HStack{
                        Spacer()
                        Button(action: {
                            isDarkMode.toggle()
                        }) {
                            Image(systemName: isDarkMode ? "moon.fill" : "moon")
                                .resizable()
                                .frame(width: 24, height: 24)
                                .foregroundColor(isDarkMode ? Colors.orange : .primary)
                        }
                        
                    }
                    .padding(.horizontal, 20)
                    .padding(.top, -80)
                    
                    VStack {
                        //profile image
                        ZStack {
                            if let userImage = userViewModel.currentUser?.image {
                                KFImage(URL(string: userImage))
                                    .placeholder({ progress in
                                        ProgressView()
                                    })
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(15)
                                    .padding(.top, 21)
                                    .padding(.bottom, 8)
                            } else {
                                Image("profile_placeholder")
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
                                        .foregroundColor(Colors.orange)
                                        .frame(width: 25)
                                        .fontWeight(.bold)
                                    Image(systemName: "pencil")
                                        .foregroundColor(.white)
                                }
                            }.offset(x: 35, y: 35)
                            
                        }
                        
                        //name
                        Text(userViewModel.currentUser?.name ?? "")
                            .fontWeight(.bold)
                            .font(.system(size: 20))
                            .foregroundColor(Colors.orange)
                            .kerning(0.6)
                        
                        //email
                        Text(userViewModel.currentUser?.email ?? "")
                            .fontWeight(.light)
                            .font(.system(size: 18))
                            .foregroundColor(Colors.orange)
                            .padding(.bottom, 8)
                        VStack{
                            Button(action: {
                                do {
                                    try authVM.logout()
                                } catch {
                                    print(error)
                                }
                            }) {
                                Text("Logout")
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 7)
                                    .font(.system(size: 19))
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                    .background(Colors.orange)
                                    .cornerRadius(100)
                            }
                        }
//                        .padding(.top, 30)
                    }
                }
                .ignoresSafeArea()
            }
            .preferredColorScheme(isDarkMode ? .dark : .light)
            .task {
                do {
                    _ = try await userViewModel.getUserProfile()
                } catch {
                    print(error)
                }
            }
        }
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showPicker) {
            ImagePicker(show: $showPicker) { url in
                Task {
                    do {
                        try await self.userViewModel.uploadUserProfile(localURL: url)
                    } catch {
                        print(error)
                    }
                }
            }
        }
    }
}


struct ProfileHeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderComponent()
    }
}
