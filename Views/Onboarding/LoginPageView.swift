//
//  LoginPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI

struct LoginPageView: View {
    
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var avm = AuthenticationViewModel()
    @State private var emailTxt = ""
    @State private var passwordTxt = ""
    @State var changePage = 1
    
    var body: some View {
        ZStack{
            if changePage == 1 {
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
                    Text("Let’s Connect!")
                        .fontWeight(.heavy)
                        .font(.system(size: 36))
                        .foregroundColor(.white)
                        .padding(.top, 180)
                        .padding(.bottom, 95)
                    
                    CustomTextField(label: "Email", placeholder: "Enter your email address", text: $emailTxt)
                        .padding(.bottom, 10)
                    CustomTextField(label: "Password", placeholder: "Enter your password", text: $passwordTxt, showText: false)
                }
                
                VStack{
                    Spacer()
                    Button(action: {
                        avm.auth(email: emailTxt, password: passwordTxt)
                    }) {
                        CustomButton(text: "LOGIN")
                    }
                    .disabled(avm.checkLogin(email: emailTxt, password: passwordTxt))
                    .opacity(avm.checkLogin(email: emailTxt, password: passwordTxt) ? 0.5 : 1.0)
                    
                    HStack {
                        Text("Don't have an account yet?")
                            .italic()
                            .fontWeight(.light)
                            .font(.system(size: 15))
                        Button{
                            changePage = 2
                        } label: {
                            Text("Register Now")
                                .italic()
                                .fontWeight(.bold)
                                .foregroundColor(Color("Orange"))
                                .font(.system(size: 15))
                        }
                    }
                    .padding(.bottom, 90)
                }
            }else if changePage == 2{
//                RegisterPageView()
                DiscoverPageView(communityViewModel: CommunityViewModel())
//                CommunityPageView(communityViewModel: CommunityViewModel())
            }
        }
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}
