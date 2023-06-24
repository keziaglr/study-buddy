//
//  BadgeComponent.swift
//  mini2
//
//  Created by Randy Julian on 23/06/23.
//

import SwiftUI

struct BadgeComponent: View {
    var body: some View {
        VStack {
            Text("Your Badges Collection")
                .fontWeight(.bold)
                .font(.system(size: 20))
                .padding(.bottom, 19)
            List {
                HStack {
                    Image("badge1")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Text("Be a community leader")
                        .padding(.leading, 20)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                }

                HStack {
                    Image("badge1")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Text("Be a community leader")
                        .padding(.leading, 20)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                }
                
                HStack {
                    Image("badge1")
                        .resizable()
                        .frame(width: 70, height: 70)
                    Text("Be a community leader")
                        .padding(.leading, 20)
                        .fontWeight(.bold)
                        .font(.system(size: 15))
                }
            }
            .listStyle(.plain)
            .padding(EdgeInsets(top: 0, leading: 32, bottom: 0, trailing: 32))
        }
        .padding(.top, 330)
    }
}

struct BadgeComponent_Previews: PreviewProvider {
    static var previews: some View {
        BadgeComponent()
    }
}
