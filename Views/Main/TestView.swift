//
//  TestView.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 26/06/23.
//

import SwiftUI



struct TestView: View {
    @State private var title: String = ""
    @State private var description: String = ""
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
                            
                        }label: {
                            Image(systemName: "photo")
                          
                        }
                    
                            
                    }.padding(.horizontal , geometry.size.width * 0.05)
                   
              
                    
                        
                        
                     
                    
                }.frame(width: geometry.size.width * 0.8 , height: geometry.size.width * 0.15)
                    .position(x: geometry.size.width / 2 , y: geometry.size.height * 0.58)
                
                Button{
                    
                }label: {
                  
                    CustomButton(text: "Create Community")
                }.position(x: geometry.size.width / 2, y: geometry.size.height * 0.8)
            }
            
            
        }.ignoresSafeArea()
    }
}

struct TestView_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
        
    }
}
