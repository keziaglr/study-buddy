//
//  SetScheduleView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI
import EventKit

struct SetScheduleView: View {
    
    @Binding var isPresent: Bool
    @Binding var isBadge: Bool
    @Binding var badge: String
    @Binding var community : Community
    @State var startStudySchedule = Date()
    @State var endStudySchedule = Date()
    @State var vm = BadgeViewModel()
    @State var cvm = CommunityViewModel()
    @State private var showAlert = false
    
    
    var body: some View {
        
        
        GeometryReader { geometry in
            VStack{
                //Title
                Text("Study Schedule")
                    .fontWeight(.bold)
                    .font(.system(size: 25))
                    .foregroundStyle(Colors.orange)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.1)
                
                //Clock Image
                Image("studytime")
                    .resizable()
                    .frame(width: 220, height: 220)
//                    .aspectRatio(contentMode: .fill)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.1)
                
                
                //Start Study Schedule Buttons
                VStack{
                    HStack{
                        //Start Text
                        Text("Start")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                        
                        Spacer()
                        
                        //Start Time Picker
                        DatePicker("", selection: $startStudySchedule, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .colorInvert()
                            .colorMultiply(Color.blue)
                            .onAppear{
                                startStudySchedule = community.startDate ?? Date()
                            }
                    }
//                    .frame(width: geometry.size.width*0.7557)
//                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.12)
                    
                    Divider()
                        .foregroundColor(Color("Gray"))
                        .frame(width: geometry.size.width*0.6)
                        .padding(EdgeInsets(top: geometry.size.height*0.02567394, leading: 0, bottom: geometry.size.height*0.02567394, trailing: 0))
                    
                    //End Time Picker
                    HStack {
                        //End Text
                        Text("End")
                            .fontWeight(.medium)
                            .font(.system(size: 18))
                        
                        Spacer()
                        
                        //End Time Picker
                        DatePicker("", selection: $endStudySchedule, displayedComponents: [.date, .hourAndMinute])
                            .datePickerStyle(.compact)
                            .labelsHidden()
                            .colorInvert()
                            .colorMultiply(Color.blue)
                            .onAppear{
                                endStudySchedule = community.endDate ?? Date()
                            }
                    }
                }
                .frame(width: geometry.size.width*0.7557)
                .position(x: geometry.size.width / 2 , y: geometry.size.height / 5)
                
                //Set Schedule Button
                Button {
                    Task {
                        do {
                            try await cvm.setSchedule(startDate: startStudySchedule, endDate: endStudySchedule, communityID: community.id!)
                            showAlert = true
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    CustomButton(text: "Set Study Schedule", primary: false)
                } .alert(isPresented: $showAlert) {
                    Alert(
                        title: Text("Success!"),
                        message: Text("Your action was successful."),
                        dismissButton: .default(Text("OK"))
                    )
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 3.3)
                
                
                Button {
                    addEventToCalendar()
                } label: {
                    Text("Add to Calendar")
                        .fontWeight(.medium)
                        .font(.system(size: 18))
                }
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
                event.title = "\(community.title)'s Study Schedule"
                event.startDate = startStudySchedule
                event.endDate = endStudySchedule
                
                
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                let badgeId = self.vm.getBadgeID(badgeName: "Collaborative Dynamo")
                do {
                    try eventStore.save(event, span: .thisEvent)
                    print("Event added to calendar")
                    isPresent = false
                    vm.validateBadge(badgeId: badgeId) { b in
                        if !b {
                            badge = "Collaborative Dynamo"
                            isBadge = true
                            vm.achieveBadge(badgeId: badgeId)
                        }
                    }
                } catch {
                    print("Error saving event: \(error.localizedDescription)")
                }
            } else {
                print("Access denied or error: \(error?.localizedDescription ?? "")")
            }
        }
    }
}




//struct SetSchedule_Previews: PreviewProvider {
//    static var previews: some View {
//        SetScheduleView(isPresent: .constant(false), isBadge: .constant(false), badge: .constant("badge1"))
//    }
//}
