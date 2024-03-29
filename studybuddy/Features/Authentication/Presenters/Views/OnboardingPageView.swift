//
//  OnboardingPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI
import LottieUI

struct OnboardingPageView: View {
    @EnvironmentObject var authViewModel: AuthenticationViewModel
    @State var goToRegister = false
    @State var goToLogin = false
    @State var goToReset = false
    var body: some View {
        NavigationStack {
            ZStack {
                Images.backgroundGradient
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack{
                    Text("Find Perfect Buddy!")
                        .fontWeight(.bold)
                        .font(.system(size: 30))
                        .kerning(0.9)
                        .foregroundColor(Colors.orange)
                        .padding(.top, -320)
                }
                
                ZStack{
                    LottieView("community")
                        .loopMode(.loop)
                        .frame(width: 295)
                        .padding(.bottom, 232)
                }
                
                VStack{
                    Text("Discover, Connect, and Thrive\nwith your Perfect\nStudy Buddy")
                        .multilineTextAlignment(.center)
                        .fontWeight(.medium)
                        .font(.system(size: 24))
                        .kerning(0.72)
                        .foregroundColor(Colors.orange)
                        .padding(.top, 485)
                    Spacer()
                    Button(action: {
                        goToLogin = true
                    }) {
                        CustomButton(text: "Login")
                    }
                    
                    Button(action: {
                        goToRegister = true
                    }) {
                        CustomButton(text: "Register", primary: false)
                    }
                    .padding()
                    .padding(.bottom, 97)
                }
            }
            .navigationDestination(isPresented: $goToRegister) {
                RegisterPageView()
            }
            .navigationDestination(isPresented: $goToLogin) {
                LoginPageView()
            }
            .navigationDestination(isPresented: $goToReset) {
                ResetPasswordPageView()
            }
        }
    }
}



struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView()
    }
}
