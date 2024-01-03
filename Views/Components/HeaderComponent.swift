//
//  RecommendationPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct HeaderComponent: View {
    @State var text = "Title"
    
    var body: some View {
        VStack {
            ZStack{
                Image("header_gradient")
                    .resizable()
                    .scaledToFit()
                
                //Header Title
                HStack {
                    Text(text)
                        .fontWeight(.bold)
                        .foregroundColor(Color("Orange"))
                        .kerning(0.75)
                        .font(.system(size: 25))
                        .padding(.leading, 50)
                        .padding(.top, 53)
                    
                    Spacer()
                }
            }
            .edgesIgnoringSafeArea(.all)
            
            Spacer()
                
        }
    }
}

struct HeaderComponent_Previews: PreviewProvider {
    static var previews: some View {
        HeaderComponent()
    }
}
