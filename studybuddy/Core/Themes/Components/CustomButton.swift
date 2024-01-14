//
//  CustomButton.swift
//  studybuddy
//
//  Created by Kezia Gloria on 23/06/23.
//

import SwiftUI

struct CustomButton: View {
    @State var text = "Label"
    @State var primary : Bool = true
    var body: some View {
        if primary {
            Text(text)
                .frame(width: 302, height: 40)
                .font(.system(size: 18))
                .bold()
                .foregroundColor(.white)
                .background(Colors.orange)
            .cornerRadius(10)
        }else{
            Text(text)
                .frame(width: 302, height: 40)
                .font(.system(size: 18))
                .bold()
                .foregroundColor(Colors.orange)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Colors.orange, lineWidth: 2)
                )
        }
    }
}

struct CustomButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomButton()
    }
}
