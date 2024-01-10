//
//  RegisterPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI

struct RegisterPageView: View {
    
    @EnvironmentObject private var viewModel: AuthenticationViewModel
    @Binding var changePage : Int
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
                    Images.onboarding1
                        .resizable()
                        .scaledToFit()
                        .frame(width: 260)
                        .padding(.bottom, 420)
                }
                
                VStack{
                    Text("Let’s Get Started!")
                        .fontWeight(.heavy)
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .padding(.top, 180)
                        .padding(.bottom, 10)
                    
                    CustomTextField(label: "Full Name", placeholder: "Enter your full name", text: $viewModel.name)
                        .padding(.bottom, 10)
                    
                    CustomTextField(label: "Email", placeholder: "Enter your email address", text: $viewModel.email)
                        .padding(.bottom, 10)
                    
                    CustomTextField(label: "Password", placeholder: "Enter your password", text: $viewModel.password, showText: false)
                }
                
                VStack{
                    Spacer()
                    Button(action: {
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
                    }) {
                        CustomButton(text: "REGISTER")
                    }
                    .disabled(viewModel.checkRegister())
                    .opacity(viewModel.checkRegister() ? 0.5 : 1.0)
                    
                    HStack {
                        Text("Already have an account yet?")
                            .italic()
                            .fontWeight(.light)
                            .font(.system(size: 15))
                        Button{
                            changePage = 2
                        } label: {
                            Text("Login Now")
                                .italic()
                                .fontWeight(.bold)
                                .foregroundColor(Colors.orange)
                                .font(.system(size: 15))
                        }
                    }
                    .padding(.bottom, 90)
                }
                if isLoading {
                    LoaderComponent()
                }
            }
            .navigationDestination(isPresented: $viewModel.created) {
                InterestPageView()
            }
            .alert(isPresented: $showingAlert) {
                Alerts.errorRegister
            }
        }
    }
}

struct RegisterPageView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPageView(changePage: .constant(1))
            .environmentObject(AuthenticationViewModel())
    }
}
