//
//  ProfilePageView.swift
//  mini2
//
//  Created by Randy Julian on 23/06/23.
//

import SwiftUI
import Foundation
import Kingfisher

struct ProfileHeaderComponent: View {
    @StateObject private var userViewModel = UserViewModel()
    @EnvironmentObject var authVM: AuthenticationViewModel
    @State var logout = false
    @State var showPicker = false
    @Binding var isLoading: Bool
    @AppStorage("isDarkMode") private var isDarkMode = false
    @ObservedObject var userManager = UserManager.shared
    
    var body: some View {
        ZStack {
            Images.profileGradient
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
                    if let userImage = userManager.currentUser?.image, !userImage.isEmpty {
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
                        Images.profilePlaceholder
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
                Text(userManager.currentUser?.name ?? "")
                    .fontWeight(.bold)
                    .font(.system(size: 20))
                    .foregroundColor(Colors.orange)
                    .kerning(0.6)
                
                //email
                Text(userManager.currentUser?.email ?? "")
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
            }
        }
        .ignoresSafeArea()
        .navigationBarBackButtonHidden()
        .sheet(isPresented: $showPicker) {
            ImagePicker(show: $showPicker) { url in
                Task {
                    do {
                        isLoading = true
                        try await self.userViewModel.uploadUserProfile(localURL: url)
                    } catch {
                        print(error)
                    }
                    isLoading = false
                }
            }
            .ignoresSafeArea()
        }
    }
}


struct ProfileHeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        ProfileHeaderComponent(isLoading: .constant(false))
    }
}
