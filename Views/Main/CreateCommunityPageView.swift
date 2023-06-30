//
//  CreateCommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI
import PhotosUI

struct CreateCommunityPageView: View {
    @ObservedObject var communityViewModel: CommunityViewModel
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var category: String = ""
    @State private var url: URL = URL(string: "https://www.example.com")!
    @State var selectedPhoto: [PhotosPickerItem] = []
    @State var data: Data?
    @State var showpicker = false
    
    var body: some View {
        
        ZStack{
            GeometryReader { geometry in
                Color("Gray")
                
                Text("Set up Community Profile")
                    .fontWeight(.bold)
                    .font(.system(size: 21))
                    .position(x: geometry.size.width / 2, y: geometry.size.height * 0.1 )
                
                ZStack(alignment: .leading){
                    
                    //Title Field
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 15)
                    
                    Text("Title")
                        .fontWeight(.medium)
                        .padding(.leading , geometry.size.width * 0.03)
                        .position(x: geometry.size.width * 0.07, y: geometry.size.height * 0.035)
                    
                    TextField("input community title", text: $title)
                        .position(x: geometry.size.width * 0.45, y: geometry.size.height * 0.08)
                    
                }.frame(width: geometry.size.width * 0.8 , height: geometry.size.width * 0.25)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.3)
                
                ZStack(alignment: .leading){
                    
                    //Title Field
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 15)
                    
                    Text("Description")
                        .fontWeight(.medium)
                        .padding(.leading , geometry.size.width * 0.03)
                        .position(x: geometry.size.width * 0.15, y: geometry.size.height * 0.035)
                    
                    TextField("input community title", text: $description)
                        .position(x: geometry.size.width * 0.45, y: geometry.size.height * 0.08)
                    
                }.frame(width: geometry.size.width * 0.8 , height: geometry.size.width * 0.25)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.45)
                
                ZStack(alignment: .leading){
                    
                    //Title Field
                    RoundedRectangle(cornerRadius: 10)
                        .foregroundColor(.white)
                        .shadow(radius: 15)
                    
                    HStack{
                        
                        
                        Text("Choose Image")
                            .fontWeight(.medium)
                        
                        
                        
                        
                        Spacer()
                        
                        Button{
                            showpicker = true
                        }label: {
                            Image(systemName: "photo")
                        }
                        
                       
                        
                        
                        
                    }.padding(.horizontal , geometry.size.width * 0.05)
                    
                    
                    
                    
                    
                    
                    
                }.frame(width: geometry.size.width * 0.8 , height: geometry.size.width * 0.15)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.58)
                
                Button{

                    communityViewModel.addCommunity(title: title, description: description, url: url, category: category)
                    
                }label: {
                    
                    CustomButton(text: "Create Community")
                }.position(x: geometry.size.width / 2, y: geometry.size.height * 0.8)
            }
            
            
        }.ignoresSafeArea()
            .sheet(isPresented: $showpicker) {
                ImagePicker(show: $showpicker) { url in
                    self.url = url
                }
            }
           
        
    }
    
}

//struct CreateCommunityPageView_Previews: PreviewProvider {
//    static var previews: some View {
//        CreateCommunityPageView(communityViewModel: CommunityViewModel(), url: URL)
//           
//    }
//}
