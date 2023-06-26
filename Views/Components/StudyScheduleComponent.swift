//
//  StudyScheduleComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

import SwiftUI

struct StudyScheduleComponent: View {
    var body: some View {
        HStack{
            
            //Study Schedule Text
            Text("Study Schedule")
                .foregroundColor(Color.white)
                .fontWeight(.medium)
                .font(.system(size: 16))
                .padding(EdgeInsets(top: 12, leading: 30, bottom: 12, trailing: 0))
            
            Spacer()
            
            //Schedule
            ZStack {
                Capsule()
                    .foregroundColor(.white)
                    .frame(width: 83, height: 25)
                
                Text("07.00 PM")
                    .fontWeight(.bold)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30))
        }
        .background(Color(red: 0.906, green: 0.467, blue: 0.157))
        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
    }
}

struct StudyScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        StudyScheduleComponent()
            .previewLayout(PreviewLayout.sizeThatFits)
    }
}

