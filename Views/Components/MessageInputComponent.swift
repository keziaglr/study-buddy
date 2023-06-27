//
//  MessageInputComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct MessageInputComponent: View {
    
    @State private var testText: String = ""
    @EnvironmentObject var manager : MessageManager
    @State var communityID = ""
    
    var body: some View {
        ZStack {
            TextField("", text: $testText, axis: .vertical)
                .keyboardType(.default)
                .padding(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 50))
                .overlay(
                    RoundedRectangle(cornerRadius: 40)
                        .stroke(Color(red: 0.906, green: 0.467, blue: 0.157), lineWidth: 2)
                )
                .lineLimit(5)
            
            //Send Button
            HStack {
                Spacer()
                Button {
                    manager.sendChats(text: testText, communityID: communityID)
                    testText = ""
                } label: {
                    ZStack(alignment: .center) {
                        Circle()
                            .fill(Color(red: 0.906, green: 0.467, blue: 0.157))
                            .frame(width: 33, height: 33)
                        
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .foregroundColor(Color.white)
                            .frame(width: 20, height: 20)
                    }
                    .frame(width: 33, height: 33) // Add this line to set the fixed size of the ZStack
                }
                .disabled(testText == "")
                .opacity(testText == "" ? 0.5 : 1.0)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 5))
            }
        }
    }
}

struct CustomTextfield: TextFieldStyle {
    
    let systemImageString: String
    
    // Hidden function to conform to this protocol
    func _body(configuration: TextField<Self._Label>) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 5.0)
                .stroke(
                    LinearGradient(
                        colors: [
                            .red,
                            .blue
                        ],
                        startPoint: .leading,
                        endPoint: .trailing
                    )
                )
                .frame(height: 40)
            
            HStack {
                Image(systemName: systemImageString)
                // Reference the TextField here
                configuration
            }
            .padding(.leading)
            .foregroundColor(.gray)
        }
    }
}

struct MessageInputComponent_Previews: PreviewProvider {
    static var previews: some View {
        MessageInputComponent()
    }
}

