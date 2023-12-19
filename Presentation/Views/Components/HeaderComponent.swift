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
                        .foregroundColor(.white)
                        .font(.system(size: 30))
                        .padding(.leading, 50)
                    
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
