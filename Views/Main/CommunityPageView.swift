//
//  CommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI

struct CommunityPageView: View {
    var body: some View {
        ZStack {
            HeaderComponent(text: "Your Learning Squad!")

            VStack(spacing: -100) {
                //for-each disini
                CardComponent()

            }
            .padding(.top, 180)
            
        }
    }
}

struct CommunityPageView_Previews: PreviewProvider {
    static var previews: some View {
        CommunityPageView()
    }
}
