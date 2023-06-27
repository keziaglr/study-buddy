//
//  RegisterPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI

struct RegisterPageView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var emailTxt: String = ""
    @State private var passwordTxt: String = ""
    @State private var avm = AuthenticationViewModel()
    @Binding var changePage : Int
    
    var body: some View {
        ZStack{
                Image("background_gradient")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                VStack{
                    Image("onboard1")
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
                    
                    CustomTextField(label: "Full Name", placeholder: "Enter your full name", text: $name)
                        .padding(.bottom, 10)
                    
                    CustomTextField(label: "Email", placeholder: "Enter your email address", text: $emailTxt)
                        .padding(.bottom, 10)
                    
                    CustomTextField(label: "Password", placeholder: "Enter your password", text: $passwordTxt, showText: false)
                }
                
                VStack{
                    Spacer()
                    Button(action: {
                        avm.createUser(name: name, email: emailTxt, password: passwordTxt)
                    }) {
                        CustomButton(text: "REGISTER")
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
        }
    }
}

struct RegisterPageView_Previews: PreviewProvider {
    static var previews: some View {
        RegisterPageView(changePage: .constant(1))
    }
}
