//
//  SetScheduleView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI
import EventKit

struct SetScheduleView: View {
    
    @State private var StartStudySchedule = Date()
    @State private var EndStudySchedule = Date()
    
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack{
                //Title
                Text("Schedule Your Meeting!")
                    .fontWeight(.bold)
                    .font(.system(size: 21))
                    .padding(EdgeInsets(top: geometry.size.height*0.07702182, leading: 0, bottom: 0, trailing: 0))
                
                //Clock Image
                Image(systemName: "clock")
                    .resizable()
                    .foregroundColor(Color(red: 0.259, green: 0.447, blue: 0.635))
                    .frame(width: 108,height: 108)
                    .padding(EdgeInsets(top: geometry.size.height*0.07702182, leading: 0, bottom: 62, trailing: 0))
                
                
                //Start Study Schedule Buttons
                HStack{
                    //Start Text
                    Text("Start")
                        .fontWeight(.medium)
                        .font(.system(size: 18))
                    
                    Spacer()
                    
                    //Start Time Picker
                    DatePicker("", selection: $StartStudySchedule, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorInvert()
                        .colorMultiply(Color.blue)
                }
                .frame(width: geometry.size.width*0.7557)
                
                Divider()
                    .foregroundColor(Color("Gray"))
                    .frame(width: geometry.size.width*0.6743)
                    .padding(EdgeInsets(top: geometry.size.height*0.02567394, leading: 0, bottom: geometry.size.height*0.02567394, trailing: 0))
                
                //End Time Picker
                HStack {
                    //End Text
                    Text("End")
                        .fontWeight(.medium)
                        .font(.system(size: 18))
                    
                    Spacer()
                    
                    //End Time Picker
                    DatePicker("", selection: $EndStudySchedule, displayedComponents: [.date, .hourAndMinute])
                        .datePickerStyle(.compact)
                        .labelsHidden()
                        .colorInvert()
                        .colorMultiply(Color.blue)
                }
                .frame(width: geometry.size.width*0.7557)
                
                //Set Schedule Button
                Button {
                    addEventToCalendar()
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
                .padding(EdgeInsets(top: geometry.size.height*0.24261874, leading: 0, bottom: 0, trailing: 0))
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 116, trailing: 0))
            .background(Color(red: 0.965, green: 0.965, blue: 0.965))
        
        }
    }
    
    private func addEventToCalendar() {
        let eventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { granted, error in
            if granted && error == nil {
                let event = EKEvent(eventStore: eventStore)
                event.title = "Study Schedule"
                event.startDate = StartStudySchedule
                event.endDate = EndStudySchedule
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Event added to calendar")
                } catch {
                    print("Error saving event: \(error.localizedDescription)")
                }
            } else {
                print("Access denied or error: \(error?.localizedDescription ?? "")")
            }
        }
    }
}




struct SetSchedule_Previews: PreviewProvider {
    static var previews: some View {
        SetScheduleView()
    }
}
