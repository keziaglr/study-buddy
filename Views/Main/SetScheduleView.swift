//
//  SetScheduleView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct SetScheduleView: View {
    
    @State var studySchedule: Date = .now
    
    var body: some View {
        VStack{
            
            //Title
            Text("Schedule Your Meeting!")
                .fontWeight(.bold)
                .font(.system(size: 21))
                .padding(.top)
            
            //Clock Image
            Image(systemName: "clock")
                .resizable()
                .foregroundColor(Color(red: 0.259, green: 0.447, blue: 0.635))
                .frame(width: 108,height: 108)
                .padding(EdgeInsets(top: 46, leading: 0, bottom: 62, trailing: 0))
            
            
            
            //Time Picker
            ZStack{
                Rectangle()
                    .fill(Color.white)
                    .frame(width: 302, height: 68)
                    .cornerRadius(20, corners: .allCorners)
                    .shadow(radius: 15)
                
                //Buttons
                HStack{
                    
                    //Time Picker
                    DatePicker("", selection: $studySchedule, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                    
                    //Segmented Picker
                }
                .padding(EdgeInsets(top: 0, leading: 10, bottom: 0, trailing: 10))
                .frame(width: 302, height: 108)
                
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 271, trailing: 0))
            
            Spacer()
            
            //Set Schedule Button
            Button {
                print("tapped")
            } label: {
                ZStack(alignment: .center) {
                    Rectangle()
                        .fill(Color(red: 0.906, green: 0.467, blue: 0.157))
                        .frame(width: 297, height: 40)
                        .cornerRadius(10, corners: .allCorners)
                    
                    Text("Set Schedule")
                        .foregroundColor(Color.white)
                        .fontWeight(.bold)
                        .font(.system(size: 19))
                }
                .frame(width: 33, height: 33) // Add this line to set the fixed size of the ZStack
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .padding(EdgeInsets(top: 0, leading: 0, bottom: 116, trailing: 0))
        .background(Color(red: 0.965, green: 0.965, blue: 0.965))
        
    }
}

struct SetScheduleView_Previews: PreviewProvider {
    static var previews: some View {
        SetScheduleView()
    }
}
