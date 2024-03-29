//
//  CustomTextField.swift
//  studybuddy
//
//  Created by Kezia Gloria on 23/06/23.
//

import SwiftUI

struct CustomTextField: View {
    @State var label : String = "Label"
    @State var placeholder : String = "This is placeholder"
    @Binding var text : String
    @State var showText : Bool = true
    var body: some View {
        ZStack {
            HStack {
                if showText {
                    TextField(placeholder, text: $text)
                        .kerning(0.54)
                        .keyboardType(.default)
                        .foregroundColor(Colors.black)
                }else{
                    SecureField(placeholder, text: $text)
                        .kerning(0.54)
                        .keyboardType(.default)
                        .foregroundColor(Colors.black)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 7)
            .frame(width: 351, height: 47, alignment: .leading)
            .cornerRadius(10)

            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .inset(by: 1)
                    .stroke(Colors.orange, lineWidth: 2)
                    .shadow(color: .black.opacity(0.25), radius: 5, x: 0, y: 4)
                
            )
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: .constant("Hello"))
    }
}
