//
//  RegisterPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI
import LottieUI

struct RegisterPageView: View {
    
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    @State private var showingAlert = false
    @State private var isLoading = false
    @State private var goToLogin = false
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                ZStack{
                    Images.backgroundGradient
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack{
                        Text("Let's get Started!")
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .kerning(0.9)
                            .foregroundColor(Colors.orange)
                            .padding(.top, 105)
                        
                        ZStack{
                            Image("login-register")
                                .resizable()
                                .frame(width: 250, height: 250)
                                .padding(.bottom, 400)
                                .padding(.top, 60)
                            
                            VStack(spacing: 20) {
                                CustomTextField(label: "Name", placeholder: "Name", text: $viewModel.name)
                                    .padding(.top, 160)
                                
                                CustomTextField(label: "Email", placeholder: "Email", text: $viewModel.email)
                                
                                CustomTextField(label: "Password", placeholder: "Password", text: $viewModel.password, showText: false)
                            }
                        }
                    }
                    .position(x : geometry.size.width / 2, y : geometry.size.height / 2)
                    
                    VStack{
                        Spacer()
                        
                        Button{
                            Task {
                                do {
                                    isLoading = true
                                    try await viewModel.createUser()
                                    showingAlert = false
                                } catch {
                                    print(error)
                                    showingAlert = true
                                }
                                isLoading = false
                            }
                        } label: {
                            CustomButton(text: "Register")
                                .disabled(viewModel.checkRegister())
                                .opacity(viewModel.checkRegister() ? 0.5 : 1.0)
                        }
                        
                        HStack {
                            Text("Already have an account yet?")
                                .italic()
                                .fontWeight(.light)
                                .font(.system(size: 15))
                            Button{
                                goToLogin = true
                            } label: {
                                Text("Login Now")
                                    .italic()
                                    .fontWeight(.bold)
                                    .foregroundColor(Colors.orange)
                                    .font(.system(size: 15))
                            }
                        }
                    }
                    .padding(.bottom, 90)
                    .position(x : geometry.size.width / 2, y : geometry.size.height / 2)
                    
                    if isLoading {
                        LoaderComponent()
                    }
                }
                .navigationDestination(isPresented: $viewModel.created) {
                    InterestPageView()
                }
                .navigationDestination(isPresented: $goToLogin) {
                    LoginPageView()
                }
                .alert(isPresented: $showingAlert) {
                    Alerts.errorRegister
                }
                .navigationBarBackButtonHidden()
            }
        }
    }
}

struct RegisterPageView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPageView()
            .environmentObject(AuthenticationViewModel())
    }
}
