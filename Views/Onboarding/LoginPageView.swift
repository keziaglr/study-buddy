//
//  LoginPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI
import LottieUI

struct LoginPageView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @ObservedObject private var avm = AuthenticationViewModel()
    @State private var emailTxt = ""
    @State private var passwordTxt = ""
    @Binding var changePage : Int
    @State var moveToHome = false
    var body: some View {
        NavigationStack {
            ZStack{
                    Image("background_gradient")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()
                    
                    VStack{
                        Text("Welcome Back 👋🏼")
                            .fontWeight(.bold)
                            .font(.system(size: 30))
                            .kerning(0.9)
                            .foregroundColor(Color("Orange"))
                            .padding(.top, 105)
                        
                        ZStack{
                            LottieView("community")
                                .loopMode(.loop)
                                .frame(width: 329)
                                .padding(.bottom, 391)

                            VStack(spacing: 20) {
                                CustomTextField(label: "Email", placeholder: "Email", text: $emailTxt)
                                    .padding(.top, 105)
                                
                                CustomTextField(label: "Password", placeholder: "Password", text: $passwordTxt, showText: false)
                            }
                        }
                    }
                    
                    VStack{
                        Spacer()
                        Button(action: {
                            avm.auth(email: emailTxt, password: passwordTxt)
                        }) {
                            CustomButton(text: "Login")
                        }
                        .disabled(avm.checkLogin(email: emailTxt, password: passwordTxt))
                        .opacity(avm.checkLogin(email: emailTxt, password: passwordTxt) ? 0.5 : 1.0)
                        
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
                                    .foregroundColor(Color("Orange"))
                                    .font(.system(size: 15))
                            }
                        }
                        .kerning(0.45)
                        .padding(.bottom, 90)
                    }
                    .navigationDestination(isPresented: $avm.authenticated) {
                        TabBarNavigation()
//                        InterestPageView()
                    }
                
                }
        }.navigationBarBackButtonHidden()
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView(changePage: .constant(1))
    }
}
