//
//  Searchbar.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 30/06/23.
//
import SwiftUI

struct SearchBarComponent: View {
    @Binding var text: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: UIScreen.main.bounds.width * 0.9 , height: UIScreen.main.bounds.height * 0.07)
                .foregroundColor(Color("Orange"))
            
            RoundedRectangle(cornerRadius: 50)
                .frame(width: UIScreen.main.bounds.width * 0.88 , height: UIScreen.main.bounds.height * 0.06)
                .frame(height: 45)
                .foregroundColor(Color("Gray"))
            
            HStack {
                Spacer()
                TextField("Search Your Community Here", text: $text)
                    .padding(.leading , 20)
                Button{
                    text = ""
                }label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                }
            
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
}

#Preview {
    SearchBarComponent(text: .constant(""))
}
