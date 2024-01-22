//
//  BadgeEarnedView.swift
//  mini2
//
//  Created by Randy Julian on 28/06/23.
//

import SwiftUI
import LottieUI

struct BadgeEarnedView: View {
    @State var badge: Badge?
    @State private var isBouncing = false
    let bounceInterval: TimeInterval = 0.8
    
    var body: some View {
        ZStack {
            
            VStack{
                Text("New Badge Earned!")
                    .fontWeight(.bold)
                    .foregroundStyle(Colors.orange)
                    .font(.system(size: 26))
                    .padding(.top, 70)
                
                Spacer()
            }
            
            Image(badge!.image)
                    .resizable()
                    .frame(width: isBouncing ? 260 : 236, height: isBouncing ? 260 : 236)
                    .onAppear {
                        startBounceTimer()
                    }
                LottieView("confetti")
                    .ignoresSafeArea()
            
            VStack{
                Spacer()

                Text(badge!.description)
                    .fontWeight(.medium)
                    .font(.system(size: 20))
                    .padding(.bottom, 70)
                    .kerning(0.6)
                    .multilineTextAlignment(.center)
                    .foregroundColor(Colors.black)
                    .frame(width: 344, alignment: .top)
            }
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

#Preview {
    BadgeEarnedView(badge: Badge.data[0])
}
