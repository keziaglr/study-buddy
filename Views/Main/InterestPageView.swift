//
//  InterestPageView.swift
//  studybuddy
//
//  Created by Randy Julian on 29/06/23.
//

import SwiftUI

struct InterestPageView: View {
    var body: some View {

        VStack {
            GeometryReader { geometry in
                HeaderComponent(text: "Hello Adriel")
                
                HStack {
                    Text("Pick your interest : ")
                        .fontWeight(.medium)
                        .font(.system(size: 20))
                        .position(x: geometry.size.width / 3, y: geometry.size.height * 0.25)
                }
                
                PillsButton()
                    .frame(maxHeight: geometry.size.height/1.8)
                    .position(x: geometry.size.width / 1.75, y: geometry.size.height * 0.55)
                
                Button(action: {
                    //add action
                }) {
                    Text("CONTINUE")
                        .frame(width: 302, height: 40)
                        .font(.system(size: 18))
                        .bold()
                        .foregroundColor(.white)
                        .background(Color("Orange"))
                        .cornerRadius(10)
                }
                .position(x: geometry.size.width/2 , y: geometry.size.height * 0.900)
            }
        }
    }
}

struct InterestPageView_Previews: PreviewProvider {
    static var previews: some View {
        InterestPageView()
    }
}
