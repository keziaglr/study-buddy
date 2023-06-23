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
                Text("Let’s Connect!")
                    .fontWeight(.heavy)
                    .font(.system(size: 36))
                    .foregroundColor(.white)
                    .padding(.top, 180)
                    .padding(.bottom, 95)

                //email field
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 302, height: 70)
                        .shadow(radius: 15)
                    
                    VStack{
                        HStack {
                            Text("Email")
                                .fontWeight(.medium)
                                .padding(.leading, 80)
                            Spacer()
                        }
                        HStack {
                            TextField("enter your email address", text: $email)
                                .padding(.leading, 80)
                        }
                    }
                }
                
                .padding(.bottom, 10)
                
                //password field
                ZStack {
                    RoundedRectangle(cornerRadius: 10)
                        .fill(.white)
                        .frame(width: 302, height: 70)
                        .shadow(radius: 15)
                    
                    VStack{
                        HStack {
                            Text("Password")
                                .fontWeight(.medium)
                                .padding(.leading, 80)
                            Spacer()
                        }
                        HStack {
                            TextField("enter your password", text: $password)
                                .padding(.leading, 80)
                        }
                    }
                }
            }
            
            VStack{
                Spacer()
                Button(action: {
                    //add action
                }) {
                    Text("LOGIN")
                        .frame(width: 302, height: 40)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)
                        .background(Color("Orange"))
                        .cornerRadius(10)
                }
                .padding()
                .padding(.bottom, 110)
            }
        }
    }
}

struct LoginPageView_Previews: PreviewProvider {
    static var previews: some View {
        LoginPageView()
    }
}
