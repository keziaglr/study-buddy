//
//  BadgeEarnedView.swift
//  mini2
//
//  Created by Randy Julian on 28/06/23.
//

import SwiftUI
import LottieUI

struct BadgeEarnedView: View {
    @State var image : String = "badge1"
    @State private var isBouncing = false
    let bounceInterval: TimeInterval = 0.8
    
    var body: some View {
        VStack {
            ZStack{
                Image(image)
                    .resizable()
                    .frame(width: isBouncing ? 260 : 236, height: isBouncing ? 260 : 236)
                    .onAppear {
                        startBounceTimer()
                    }
                LottieView("confetti")
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            
            Text("New Badge Earned!")
                .fontWeight(.bold)
                .font(.system(size: 26))
                .padding(.top, 50)
            
            Text("Congratulatios! You just\nachieved a new badge!")
                .fontWeight(.medium)
                .font(.system(size: 18))
                .padding(.top, 10)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
            
        }
    }
    
    private func startBounceTimer() {
            Timer.scheduledTimer(withTimeInterval: bounceInterval, repeats: true) { _ in
                withAnimation(.interpolatingSpring(mass: 1.0, stiffness: 100.0, damping: 10.0, initialVelocity: 0.0)) {
                    isBouncing.toggle()
                }
            }
        }
}

struct BadgeEarnedView_Previews: PreviewProvider {
    static var previews: some View {
        BadgeEarnedView()
    }
}
