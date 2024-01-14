//
//  RegisterPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI
import LottieUI

struct RegisterPageView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var emailTxt: String = ""
    @State private var passwordTxt: String = ""
    @ObservedObject private var avm = AuthenticationViewModel()
    @Binding var changePage : Int
    
    var body: some View {
        NavigationStack {
            ZStack{
                    Image("background_gradient")
                        .resizable()
                        .scaledToFill()
                        .ignoresSafeArea()

                VStack{
                    Text("Let's get Started!")
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
                            CustomTextField(label: "Name", placeholder: "Name", text: $name)
                                .padding(.top, 105)
                            
                            CustomTextField(label: "Email", placeholder: "Email", text: $emailTxt)
                            
                            CustomTextField(label: "Password", placeholder: "Password", text: $passwordTxt, showText: false)
                        }
                    }
                }
                    
                    VStack{
                        Spacer()
                        Button(action: {
                            avm.createUser(name: name, email: emailTxt, password: passwordTxt)
                        }) {
                            CustomButton(text: "Register")
                        }
                        .disabled(avm.checkRegister(name: name, email: emailTxt, password: passwordTxt))
                        .opacity(avm.checkRegister(name: name, email: emailTxt, password: passwordTxt) ? 0.5 : 1.0)
                        
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
                                    .foregroundColor(Color("Orange"))
                                    .font(.system(size: 15))
                            }
                        }
                        .padding(.bottom, 90)
                    }
            }.navigationDestination(isPresented: $avm.created) {
                InterestPageView()
            }
        }
    }
}

struct RegisterPageView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPageView(changePage: .constant(1))
    }
}