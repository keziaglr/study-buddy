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
    @Binding var changePage : Int
    @State var moveToHome = false
    @State private var showingAlert = false
    @State private var isLoading = false
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
                        LottieView("community")
                            .loopMode(.loop)
                            .frame(width: 329)
                            .padding(.bottom, 391)
                        
                        VStack(spacing: 20) {
                            CustomTextField(label: "Email", placeholder: "Email", text: $viewModel.email)
                                .padding(.top, 105)
                            
                            CustomTextField(label: "Password", placeholder: "Password", text: $viewModel.password, showText: false)
                        }
                    }
                }
                
                VStack{
                    Spacer()
                    Button(action: {
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
                    }) {
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
                            changePage = 3
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
                .navigationDestination(isPresented: $viewModel.authenticated) {
                    TabBarNavigation()
                    //                        InterestPageView()
                }
                
                if isLoading {
                    LoaderComponent()
                }
            }
            
        }
        .navigationBarBackButtonHidden()
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
        LoginPageView(changePage: .constant(1))
            .environmentObject(AuthenticationViewModel())
    }
}
