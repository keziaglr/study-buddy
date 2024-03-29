//
//  SetScheduleView.swift
//  studybuddy
//
//  Created by Dhil Khairan Badjiser on 25/06/23.
//

import SwiftUI

struct SetScheduleView: View {
    
    @Binding var isPresent: Bool
    @Binding var showBadge: Bool
    @Binding var community : Community
    @State var startStudySchedule = Date()
    @State var endStudySchedule = Date()
    @State var showedAlert = Alert(title: Text(""))
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
                Images.studyTime
                    .resizable()
                    .frame(width: 220, height: 220)
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
                    setSchedule()
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
                showedAlert
            })
            .task {
                do {
                    try await EventStoreManager.shared.setupEventStore()
                } catch{
                    print(error)
                }
            }
        }
    }
    
    func successSetSchedule() {
        isPresent = false
        Task {
            do {
                showBadge = try await communityViewModel.validateGetCollaborativeDynamoBadge()
            } catch {
                print(error)
            }
        }
    }
    
    func setSchedule() {
        Task {
            do {
                try await communityViewModel.setSchedule(startDate: startStudySchedule, endDate: endStudySchedule, communityID: community.id!)
                community.startDate = startStudySchedule
                community.endDate = endStudySchedule
                showedAlert = Alerts.successSetSchedule {
                    successSetSchedule()
                }
                try communityViewModel.addEventToCalendar(community: community)
            } catch {
                showedAlert = Alerts.calendarPermissionFailed {
                    successSetSchedule()
                }
                print(error)
            }
            showAlert = true
        }
    }
    

}

#Preview {
    SetScheduleView(isPresent: .constant(true), showBadge: .constant(false), community: .constant(Community.previewDummy))
        .environmentObject(CommunityViewModel())
}
