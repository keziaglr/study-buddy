//
//  ChatSettingsComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct ChatSettingsComponent: View {
    
    var settings = ["Set Study Schedule", "Library", "View Members","Leave Community"]
    @State private var selectedSettings = 1
    
    var body: some View {
        Picker("", selection: $selectedSettings){
            
            Label {
                Text("Set Study Schedule")
            } icon: {
                Image(systemName: "alarm")
            }
            .tag(0)
            Label {
                Text("Library")
            } icon: {
                Image(systemName: "book")
            }
            .tag(1)
            
            Label {
                Text("View Members")
            } icon: {
                Image(systemName: "person.2")
            }
            .tag(2)
            
            Label {
                Text("Leave Community")
            } icon: {
                Image(systemName: "xmark.circle")
            }
            .tag(3)

        }
        .pickerStyle(.wheel)
    }
}

struct ChatSettingsComponent_Previews: PreviewProvider {
    static var previews: some View {
        ChatSettingsComponent()
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}
