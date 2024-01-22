//
//  ResetPasswordPageView.swift
//  studybuddy
//
//  Created by Randy Julian on 22/01/24.
//

import SwiftUI

struct ResetPasswordPageView: View {
    // TODO: change to stateObject, create state user variable
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    @State private var showingAlert = false
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
                        Text("Reset Your Password")
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
                            }
                        }
                    }
                    .position(x : geometry.size.width / 2, y : geometry.size.height / 2)
                    
                    VStack{
                        Spacer()
                        Button {
                            viewModel.resetPassword()
                            goToLogin = true
                        } label: {
                            CustomButton(text: "Send Email Verification")
                        }
                        .alert(isPresented: $showingAlert) {
                            Alerts.successSendEmail
                        }
                    }
                    .position(x : geometry.size.width / 2, y : geometry.size.height / 2.85)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $goToLogin) {
                LoginPageView()
                    .environmentObject(viewModel)
            }
        }
    }
}

#Preview {
    ResetPasswordPageView()
}
