//
//  SetScheduleView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct SetScheduleView: View {
    
    @Binding var isPresent: Bool
//    @Binding var isBadge: Bool
    @Binding var showBadge: Bool
    @Binding var community : Community
    @State var startStudySchedule = Date()
    @State var endStudySchedule = Date()
//    @State var vm = BadgeViewModel()
    @EnvironmentObject var communityViewModel: CommunityViewModel
    
    @State var showAlert = false
    
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
                            .onAppear{
                                startStudySchedule = community.startDate ?? Date()
                            }
                    }
//                    .frame(width: geometry.size.width*0.7557)
//                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.12)
                    
                    Divider()
                        .foregroundColor(Colors.gray)
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
                            try await communityViewModel.setSchedule(startDate: startStudySchedule, endDate: endStudySchedule, communityID: community.id!)
                            community.startDate = startStudySchedule
                            community.endDate = endStudySchedule
                            try await communityViewModel.addEventToCalendar(community: community)
                            showAlert = true
                        } catch {
                            print(error)
                        }
                    }
                } label: {
                    CustomButton(text: "Set Study Schedule", primary: false)
                } 
                .position(x: geometry.size.width / 2, y: geometry.size.height / 3.3)
                
                Spacer()
                
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 116, trailing: 0))
            .background(Colors.gray)
            .alert(isPresented: $showAlert, content: {
                Alerts.successSetSchedule {
                    isPresent = false
                    Task {
                        do {
                            showBadge = try await communityViewModel.validateGetCollaborativeDynamoBadge()
                        } catch {
                            print(error)
                        }
                    }
                }
            })
        }
    }
    

}




//struct SetSchedule_Previews: PreviewProvider {
//    static var previews: some View {
//        SetScheduleView(isPresent: .constant(false), isBadge: .constant(false), badge: .constant("badge1"))
//    }
//}
