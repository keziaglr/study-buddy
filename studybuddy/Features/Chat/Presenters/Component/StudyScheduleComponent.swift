//
//  StudyScheduleComponent.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct StudyScheduleComponent: View {
    @Binding var community : Community
    var body: some View {
        HStack{
            
            //Study Schedule Text
            Text("Study Schedule")
                .foregroundColor(Color.black)
                .fontWeight(.regular)
                .font(.system(size: 15))
                .kerning(0.45)
                .padding(EdgeInsets(top: 8, leading: 30, bottom: 8, trailing: 0))
            
            Spacer()
            
            //Schedule
            ZStack {
                Text(community.startDate != nil ? community.startDate!.formatted(.dateTime.hour().minute()) : "Not yet set")
                    .fontWeight(.bold)
                    .font(.system(size: 15))
                    .kerning(0.45)
                    .foregroundColor(Color.black)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 30))
        }
        .background(Colors.lightOrange)
        .frame(width: 374)
        .cornerRadius(10, corners: [.bottomLeft, .bottomRight])
    }
}

//struct StudyScheduleView_Previews: PreviewProvider {
//    static var previews: some View {
//        StudyScheduleComponent()
//            .previewLayout(PreviewLayout.sizeThatFits)
//    }
//}

