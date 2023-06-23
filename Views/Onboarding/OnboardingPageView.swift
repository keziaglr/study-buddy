//
//  OnboardingPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI

struct OnboardingPageView: View {
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
                Text("Find Perfect Buddy!")
                    .fontWeight(.black)
                    .font(.system(size: 28))
                    .foregroundColor(.white)
                Text("Discover, Connect, and Thrive\n with your Perfect\nStudy Buddy")
                    .multilineTextAlignment(.center)
                    .fontWeight(.medium)
                    .font(.system(size: 23))
                    .foregroundColor(Color("LightBlue"))
                    .padding(.top, -10)
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
                
                Button(action: {
                    //add action
                }) {
                    Text("REGISTER")
                        .frame(width: 302, height: 40)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(Color("Orange"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color("Orange"), lineWidth: 2)
                        )
                }
                .padding()
                .padding(.bottom, 110)
            }
        }
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView()
    }
}
