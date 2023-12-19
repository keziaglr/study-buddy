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
            RoundedRectangle(cornerRadius: 10)
                .fill(.white)
                .frame(width: 302, height: 70)
                .shadow(radius: 15)
            
            VStack{
                HStack {
                    Text(label)
                        .fontWeight(.medium)
                        .padding(.leading, 55)
                    Spacer()
                }
                HStack {
                    if showText {
                        TextField(placeholder, text: $text)
                            .keyboardType(.default)
                        .padding(.leading, 55)
                    }else{
                        SecureField(placeholder, text: $text)
                            .keyboardType(.default)
                        .padding(.leading, 55)
                    }
                }
            }
        }
    }
}

struct CustomTextField_Previews: PreviewProvider {
    static var previews: some View {
        CustomTextField(text: .constant("Hello"))
    }
}
