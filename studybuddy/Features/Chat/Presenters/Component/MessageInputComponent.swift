//
//  MessageInputComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct MessageInputComponent: View {
    
    @EnvironmentObject var chatViewModel : ChatViewModel
    var communityID: String
    @State var messageText: String = ""
    
    var body: some View {
        ZStack {
            TextField("", text: $messageText, axis: .vertical)
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
                    chatViewModel.sendChats(text: messageText, communityID: communityID)
                    messageText = ""
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
                    .frame(width: 33, height: 33)
                }
                .disabled(messageText == "")
                .opacity(messageText == "" ? 0.5 : 1.0)
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

#Preview {
    MessageInputComponent(communityID: Community.previewDummy.id!)
        .environmentObject(ChatViewModel())
}
