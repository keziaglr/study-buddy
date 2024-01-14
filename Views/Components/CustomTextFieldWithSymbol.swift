//
//  CustomTextFieldWithSymbol.swift
//  studybuddy
//
//  Created by Randy Julian on 12/01/24.
//

import SwiftUI

struct CustomTextFieldWithSymbol: View {
    @State var label : String = "Label"
    @State var placeholder : String = "This is placeholder"
    @State var symbol : Image
    @Binding var text : String

    var body: some View {
        ZStack {
            HStack {
                VStack{
                    Text(symbol)
                        .font(.system(size: 18))
                }
                TextField(placeholder, text: $text)
                    .kerning(0.54)
                    .keyboardType(.default)
                    .foregroundColor(.black)
                
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .frame(width: 351, height: 47, alignment: .leading)
            .cornerRadius(10)
            
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 1)
                    .stroke(Color("Orange"), lineWidth: 2)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                
            )
        }
    }
}

struct CustomTextFieldWithSymbol_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextFieldWithSymbol(symbol: Image(systemName: "text.quote") , text: .constant("Hello"))
    }
}

