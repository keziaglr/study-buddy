//
//  OnboardingPageView.swift
//  mini2
//
//  Created by Randy Julian on 21/06/23.
//

import SwiftUI

struct OnboardingPageView: View {
    @State var changePage = 1
    var body: some View {
        //TODO: Fix navigation
        ZStack {
            if changePage == 1{
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
                    Text("Discover, Connect, and Thrive\nwith your Perfect\nStudy Buddy")
                        .multilineTextAlignment(.center)
                        .fontWeight(.medium)
                        .font(.system(size: 23))
                        .foregroundColor(Color("LightBlue"))
                        .padding(.top, -10)
                }
                
                VStack{
                    Spacer()
                    Button(action: {
                        changePage = 2
                    }) {
                        CustomButton(text: "LOGIN")
                    }
                    
                    Button(action: {
                        changePage = 3
                    }) {
                        CustomButton(text: "REGISTER", primary: false)
                    }
                    .padding()
                    .padding(.bottom, 110)
                }
            }else if changePage == 2{
                LoginPageView()
            }else {
                RegisterPageView()
            }
        }
    }
}

struct OnboardingPageView_Previews: PreviewProvider {
    static var previews: some View {
        OnboardingPageView()
    }
}
