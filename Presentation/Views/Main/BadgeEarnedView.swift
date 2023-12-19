//
//  BadgeEarnedView.swift
//  mini2
//
//  Created by Randy Julian on 28/06/23.
//

import SwiftUI

struct BadgeEarnedView: View {
    @State var image : String = "badge1"
    var body: some View {
        VStack {
            ZStack{
                Image("confetti")
                Image(image)
                    .resizable()
                    .frame(width: 236, height: 236)

            }
            
            Text("New Badge Earned!")
                .fontWeight(.bold)
                .font(.system(size: 26))
                .padding(.top, 80)
            
            Text("Congratulatios! You just\nachieved a new badge!")
                .fontWeight(.medium)
                .font(.system(size: 18))
                .padding(.top, 10)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
        }
    }
}

struct BadgeEarnedView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeEarnedView()
    }
}
