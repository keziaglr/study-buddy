//
//  CreateCommunityPageView.swift
//  mini2
//
//  Created by Randy Julian on 22/06/23.
//

import SwiftUI
import PhotosUI

struct CreateCommunityPageView: View {
    
    @State private var selectedValue = "Mathematics"
    let pills = ["Mathematics", "Physics", "Biology", "Chemistry", "Economics", "Geography", "Sociology", "Law", "History - Social Science", "Computer Science", "Information Technology", "Art", "Graphic Design", "Foreign Languages", "Literature"]
    
    @ObservedObject var communityViewModel: CommunityViewModel
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var image: String = ""
    @State private var category: String = ""
    @State private var url: URL = URL(string: "https://www.example.com")!
    @State private var showError: Bool = false
    @State var selectedPhoto: [PhotosPickerItem] = []
    @State var data: Data?
    @State var showpicker = false
    
    var body: some View {
        
        ZStack{
            GeometryReader { geometry in
                Color("Gray")
                
                VStack{
                    Text("Set Up New Community")
                        .fontWeight(.bold)
                        .font(.system(size: 25))
                        .foregroundStyle(Colors.orange)
                        .kerning(0.75)
                    
                    Image("community_ilustration")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 220, height: 220)
                        .clipped()
                        .padding(.vertical, 7)
                    
                    VStack(spacing: 20){
                        CustomTextFieldWithSymbol(placeholder: "Name", symbol: Image(systemName: "character.textbox"), text: $title)
                        
                        CustomTextFieldWithSymbol(placeholder: "Short Description", symbol: Image(systemName: "text.quote"), text: $description)
                        
                        ZStack(alignment: .trailing){
                            CustomTextFieldWithSymbol(placeholder: "Image", symbol: Image(systemName: "photo"), text: $image)
                                .disabled(/*@START_MENU_TOKEN@*/true/*@END_MENU_TOKEN@*/)
                            Button{
                                showpicker = true
                            }label: {
                                Image(systemName: "photo.badge.plus")
                                    .font(.system(size: 18))
                            }
                            .padding(.trailing, 19)
                        }
                        
                        ZStack(alignment: .leading){
                            CustomTextFieldWithSymbol(placeholder: "", symbol: Image(systemName: "square.stack.3d.up"), text: $category)
                            Picker("Select option", selection: $selectedValue){
                                ForEach(pills, id: \.self){ value in
                                    Text(value).tag(value)
                                    .font(.system(size: 18))}
                            }
                            .padding(.leading, 40)
                        }
                    }
                }
                .position(x: geometry.size.width / 2, y: geometry.size.height / 2.3)
                
                Button{
                    communityViewModel.addCommunity(title: title, description: description, url: url, category: selectedValue)
                    if title.isEmpty || description.isEmpty{
                        showError = true
                    }
                }label: {
                    CustomButton(text: "Create Community", primary: false)
                }.position(x: geometry.size.width / 2, y: geometry.size.height * 0.85)
            }
            .alert(isPresented: $showError){
                Alert(title: Text("Error"),
                      message: Text("Please fill in all the fields."),
                      dismissButton: .default(Text("OK"))
                      )
            }
        }.ignoresSafeArea()
            .sheet(isPresented: $showpicker) {
                ImagePicker(show: $showpicker) { url in
                    self.url = url
                }
            }
    }
    
}

struct CreateCommunityPageView_Previews: PreviewProvider {
    static var previews: some View {
        CreateCommunityPageView(communityViewModel: CommunityViewModel())
    }
}
