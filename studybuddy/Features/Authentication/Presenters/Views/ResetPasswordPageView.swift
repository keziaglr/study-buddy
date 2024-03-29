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
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        GeometryReader { geometry in
            NavigationStack {
                
                ZStack{
                    Images.backgroundGradient
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack{
                        HStack {
                            Button {
                                presentationMode.wrappedValue.dismiss()
                            } label: {
                                Image(systemName: "arrow.backward")
                                    .resizable()
                                    .foregroundColor(Color.black)
                                    .frame(width: 20, height: 18)
                                    .padding(.leading, geometry.size.width*0.043257)
                            }
                            Spacer()
                        }
                        .padding(.top, 55)
                        
                        Text("Reset Your Password")
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .kerning(0.9)
                            .foregroundColor(Colors.orange)
                            .padding(.top, 15)
                        
                        ZStack{
                            Images.loginRegister
                                .resizable()
                                .frame(width: 250, height: 250)
                                .padding(.bottom, 400)
                                .padding(.top, 60)
                                .onTapGesture {
                                    print("tapped")
                                    hideKeyboard()
                                }
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
                            Task {
                                do {
                                    try await viewModel.resetPassword()
                                    showingAlert = true
                                    //                                    goToLogin = true
                                } catch {
                                    print(error)
                                }
                            }
                        } label: {
                            CustomButton(text: "Send Email Verification")
                        }
                    }
                    .position(x : geometry.size.width / 2, y : geometry.size.height / 2.85)
                }
            }
            .navigationBarBackButtonHidden()
            .navigationDestination(isPresented: $goToLogin) {
                LoginPageView()
            }
            .alert(isPresented: $showingAlert) {
                Alerts.successSendEmail {
                    goToLogin = true
                }
            }
        }
    }
}

#Preview {
    ResetPasswordPageView()
        .environmentObject(AuthenticationViewModel())
}
