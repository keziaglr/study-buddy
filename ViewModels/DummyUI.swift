//
//  DummyUI.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 26/06/23.
//

import SwiftUI

struct DummyUI: View {
    
    @StateObject var CommunityViewModel : CommunityViewmodel
    @Binding var communityID : String
    
    var body: some View {
        VStack{
            Text(communityID)
            
            Button{
                CommunityViewModel.removeMemberFromCommunity(communityID: communityID)
            }label: {
                Text("Exit")
            }
        }
    }
}

//struct DummyUI_Previews: PreviewProvider {
//    static var previews: some View {
//        DummyUI(CommunityViewModel: CommunityViewmodel, communityID: .constant(String("1")))
//            .environmentObject(CommunityViewmodel())
//    }
//}
