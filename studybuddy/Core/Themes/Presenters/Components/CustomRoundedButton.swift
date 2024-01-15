//
//  CustomRoundedButton.swift
//  mini2
//
//  Created by Randy Julian on 24/06/23.
//

import SwiftUI

struct CustomRoundedButton: View {
    @State var text = "Label"
    var body: some View {
        Text(text)
            .padding(.horizontal, 20)
            .padding(.vertical, 5)
            .font(.system(size: 14))
            .fontWeight(.semibold)
            .foregroundColor(.white)
            .background(Colors.orange)
            .cornerRadius(50)
    }
}

struct CustomRoundedButton_Previews: PreviewProvider {
    static var previews: some View {
        CustomRoundedButton()
    }
}
