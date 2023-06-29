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
    @State var selectedPhoto: [PhotosPickerItem] = []
    @State var data: Data?
    
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
                        
                        PhotosPicker(
                            selection: $selectedPhoto,
                            maxSelectionCount: 1,
                            matching: .images
                        ) {
                            Image(systemName: "photo")
                        }
                        
                        
                        
                    }.padding(.horizontal , geometry.size.width * 0.05)
                    
                    
                    
                    
                    
                    
                    
                }.frame(width: geometry.size.width * 0.8 , height: geometry.size.width * 0.15)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.58)
                
                Button{

                    communityViewModel.addCommunity(title: title, description: description, image: "", category: "")
                }label: {
                    
                    CustomButton(text: "Create Community")
                }.position(x: geometry.size.width / 2, y: geometry.size.height * 0.8)
            }
            
            
        }.ignoresSafeArea()
        //        Color("Gray")
        //            .edgesIgnoringSafeArea(.all)
        //            .overlay(
        //                VStack {
        //                    Text("Set up Community Profile!")
        //                        .fontWeight(.bold)
        //                        .font(.system(size: 21))
        //                        .padding(.top, 62)
        //                        .padding(.bottom, 71)
        //
        //                    //Title
        //                    ZStack {
        //                        RoundedRectangle(cornerRadius: 10)
        //                            .fill(.white)
        //                            .frame(width: 302, height: 97)
        //                            .shadow(radius: 15)
        //
        //                        VStack{
        //                            HStack {
        //                                Text("Title")
        //                                    .fontWeight(.medium)
        //                                    .padding(.leading, 60)
        //                                Spacer()
        //                            }
        //                            HStack {
        //                                TextField("input community title", text: $title)
        //                                    .frame(maxWidth: 280)
        //                                    .padding(.leading, 10)
        //
        //                            }
        //                        }
        //                    }
        //
        //                    .padding(.bottom, 28)
        //
        //                    //Description --tanya dhil
        //                    ZStack {
        //                        RoundedRectangle(cornerRadius: 10)
        //                            .fill(.white)
        //                            .frame(width: 302, height: 97)
        //                            .shadow(radius: 15)
        //
        //                        HStack {
        //                            Text("Description")
        //                                .fontWeight(.medium)
        //                                .padding(.leading, 60)
        //                                .padding(.top, -35)
        //                            Spacer()
        //                        }
        //                        VStack{
        //
        //                            HStack {
        //                                TextField("input community description", text: $description, axis: .vertical)
        //                                    .lineLimit(2)
        //                                    .frame(maxWidth: 280)
        //                                    .padding(.leading, 10)
        //                                    .padding(.top, 20)
        //                            }
        //                        }
        //                    }
        //
        //                    .padding(.bottom, 28)
        //
        //                    //Image
        //                    ZStack {
        //                        RoundedRectangle(cornerRadius: 10)
        //                            .fill(.white)
        //                            .frame(width: 302, height: 50)
        //                            .shadow(radius: 15)
        //
        //                        Group{
        //                            HStack{
        //                                Text("Choose Image")
        //                                    .frame(maxWidth: 302)
        //                                    .fontWeight(.medium)
        //                                    .padding(.leading, 40)
        //                                Spacer()
        //
        //
        //                                PhotosPicker(
        //                                    selection: $selectedPhoto,
        //                                    maxSelectionCount: 1,
        //                                    matching: .images
        //                                ) {
        //                                    Text("Pick Image")
        //                                        .frame(maxWidth: 200)
        //                                        .padding(.trailing, 20)
        //                                }
        //                                .onChange(of: selectedPhoto) { newValue in
        //                                    guard let item = selectedPhoto.first else {
        //                                        return
        //                                    }
        //
        //                                    item.loadTransferable(type: Data.self) { result in
        //                                        switch result {
        //                                        case .success(let data):
        //                                            if let data = data {
        //                                                self.data = data
        //                                            } else {
        //                                                print("Data is nil")
        //                                            }
        //                                        case .failure(let failure):
        //                                            print(failure)
        //                                        }
        //                                    }
        //                                }
        //
        //                            }
        //                            .padding()
        //
        //                            if let data = data, let uiimage = UIImage(data: data){
        //                                Image(uiImage: uiimage)
        //                                    .resizable()
        //                                    .scaledToFit()
        //                                    .frame(width: 361, height: 361)
        //                            }
        //                        }
        //                    }
        //
        //                    .padding(.bottom, 118)
        //
        //                    VStack{
        //                        Button(action: {
        //                            CommunityViewModel.addCommunity(Title: title, Description: description, Image: "")
        //                        }) {
        //                            CustomButton(text: "Create Community")
        //                        }
        //                        .padding()
        //                        .padding(.bottom, 110)
        //                    }
        //                }
        //            )
    }
    
}

struct CreateCommunityPageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCommunityPageView(communityViewModel: CommunityViewModel())
           
    }
}
