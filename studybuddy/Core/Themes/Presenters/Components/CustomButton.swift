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
                .frame(width: 351, height: 47)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .kerning(0.6)
                .foregroundColor(.white)
                .background(Colors.orange)
                .cornerRadius(100)
        }else{
            Text(text)
                .frame(width: 351, height: 47)
                .font(.system(size: 20))
                .fontWeight(.bold)
                .kerning(0.6)
                .foregroundColor(Colors.black)
                .background(Colors.white)
                .cornerRadius(100)
                .overlay(
                    RoundedRectangle(cornerRadius: 100)
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
