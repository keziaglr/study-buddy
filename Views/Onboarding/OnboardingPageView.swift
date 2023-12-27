//
//  OnboardingPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI
import LottieUI

struct OnboardingPageView: View {
    @Binding var changePage : Int
    var body: some View {
        ZStack {
            Image("background_gradient")
                .resizable()
                .scaledToFill()
                .ignoresSafeArea()
            
            VStack{
                Text("Find Perfect Buddy!")
                    .fontWeight(.bold)
                    .font(.system(size: 30))
                    .kerning(0.9)
                    .foregroundColor(Color("Orange"))
                    .padding(.top, -320)
            }
            
            ZStack{
                LottieView("community")
                    .loopMode(.loop)
                    .frame(width: 295)
                    .padding(.bottom, 230)
            }
            
            VStack{
                Text("Discover, Connect, and Thrive\nwith your Perfect\nStudy Buddy")
                    .multilineTextAlignment(.center)
                    .fontWeight(.medium)
                    .font(.system(size: 24))
                    .kerning(0.72)
                    .foregroundColor(Color("Orange"))
                    .padding(.top, 485)
                Spacer()
                Button(action: {
                    changePage = 2
                }) {
                    CustomButton(text: "Login")
                }
                
                Button(action: {
                    changePage = 3
                }) {
                    CustomButton(text: "Register", primary: false)
                }
                .padding()
                .padding(.bottom, 97)
            }
        }
    }
}



struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView(changePage: .constant(1))
    }
}
