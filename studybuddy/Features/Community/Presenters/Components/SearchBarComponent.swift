//
//  Searchbar.swift
//  studybuddy
//
//  Created by Adriel Bernard Rusli on 30/06/23.
//
import SwiftUI

struct SearchBarComponent: View {
    @Binding var searchText: String
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 50)
                .frame(width: UIScreen.main.bounds.width * 0.85 , height: UIScreen.main.bounds.height * 0.05)
                .foregroundColor(Colors.orange)
            
            RoundedRectangle(cornerRadius: 50)
                .frame(width: UIScreen.main.bounds.width * 0.83 , height: UIScreen.main.bounds.height * 0.04)
                .frame(height: 45)
                .foregroundColor(Color("Gray"))
            
            HStack {
                Spacer()
                TextField("Search your community here...", text: $searchText)
                    .italic()
                    .padding(.leading , 20)
                Button{
                    searchText = ""
                }label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(.gray)
                        .padding(.trailing, 10)
                }
            
                Spacer()
            }
            .padding(.horizontal)
        }
        .padding(.horizontal)
        .padding(.top, 16)
    }
}

#Preview {
    SearchBarComponent(searchText: .constant(""))
}
