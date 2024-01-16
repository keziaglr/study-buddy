//
//  LoginPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI
import LottieUI

struct LoginPageView: View {
    // TODO: change to stateObject, create state user variable
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    @State var moveToHome = false
    @State private var showingAlert = false
    @State private var isLoading = false
    @State private var goToRegister = false
    var body: some View {
        NavigationStack {
            ZStack{
                Images.backgroundGradient
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack{
                    Text("Welcome Back 👋🏼")
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
                            CustomTextField(label: "Email", placeholder: "Email", text: $viewModel.email)
                                .padding(.top, 105)
                            
                            CustomTextField(label: "Password", placeholder: "Password", text: $viewModel.password, showText: false)
                        }
                    }
                }
                
                VStack{
                    Spacer()
                    Button {
                        Task {
                            do {
                                isLoading = true
                                try await viewModel.auth()
                            } catch {
                                print(error)
                                showingAlert = true
                            }
                            isLoading = false
                        }
                    } label: {
                        CustomButton(text: "LOGIN")
                    }
                    .disabled(viewModel.checkLogin())
                    .opacity(viewModel.checkLogin() ? 0.5 : 1.0)
                    
                    HStack {
                        Text("Don't have an account yet?")
                            .italic()
                            .fontWeight(.light)
                            .font(.system(size: 15))
                        Button{
                            goToRegister = true
                        } label: {
                            Text("Register Now")
                                .italic()
                                .fontWeight(.bold)
                                .foregroundColor(Colors.orange)
                                .font(.system(size: 15))
                        }
                    }
                    .kerning(0.45)
                    .padding(.bottom, 90)
                }
                if isLoading {
                    LoaderComponent()
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $goToRegister) {
                RegisterPageView()
                    .environmentObject(viewModel)
            }
        }
        .onAppear{
            viewModel.password = ""
        }
        .alert(isPresented: $showingAlert) {
            Alerts.invalidCredentials
        }
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
            .environmentObject(AuthenticationViewModel())
    }
}
