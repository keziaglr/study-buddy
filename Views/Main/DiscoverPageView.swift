//
//  DiscoverPageView.swift
//  mini2
//
//  Created by Randy Julian on 24/06/23.
//

import SwiftUI

struct DiscoverPageView: View {
    @State var text = ""
    @State private var showModal = false
    
    var body: some View {
        ZStack{
            HeaderComponent(text: "Explore the Network!")
            
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 50)
                        .frame(width: 360, height: 45)
                        .foregroundColor(Color("Orange"))
                        .overlay(
                            RoundedRectangle(cornerRadius: 50)
                                .frame(width: 352, height: 38)
                                .foregroundColor(Color("Gray"))
                        )
                    HStack {
                        TextField("Search your community here ...", text: $text)
                            .italic()
                            .padding(8)
                            .padding(.leading, 15)
                            .background(Color("Gray"))
                            .cornerRadius(50)
          
                        ZStack {
                            Button{
                                text = ""
                            }label: {
                                Image(systemName: "xmark.circle.fill")
                                    .foregroundColor(.gray)
                                    .padding(8)
                            }
                        }
                    }
                    .frame(maxWidth: 350)
                }
                Spacer()
            }
            .padding(.top, 105)
            
            VStack(spacing: -100) {
                //for-each disini
                CardComponent()

            }
            .padding(.top, 180)
            
            VStack{
                Button(action: {
                    showModal = true
                }) {
                    CustomButton(text: "Create Community", primary: false)
                }
                .sheet(isPresented: $showModal){
                    ModalView()
                }
                .padding()
                .padding(.top, 600)
            }
        }
    }
}

struct ModalView: View{
    var body: some View{
        CreateCommunityPageView()
    }
}

struct DiscoverPageView_Previews: PreviewProvider {
    static var previews: some View {
        DiscoverPageView()
    }
}
