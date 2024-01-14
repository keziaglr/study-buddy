//
//  PillsButton.swift
//  studybuddy
//
//  Created by Randy Julian on 29/06/23.
//

import SwiftUI

struct PillsButtonComponent: View {
    @Binding var selectedPills: Set<String>
    
    let pills = ["Mathematics", "Physics", "Biology", "Chemistry", "Economics", "Geography", "Sociology", "Law", "History - Social Science", "Computer Science", "Information Technology", "Art", "Graphic Design", "Foreign Languages", "Literature"]
    
    var body: some View {
        VStack {
            ScrollView {
                VStack(alignment: .leading) {
                    LazyVGrid(columns: [GridItem(.flexible(minimum: 0, maximum: .infinity), spacing: 8)], spacing: 10) {
                        ForEach(pills, id: \.self) { pill in
                            Button(action: {
                                if selectedPills.contains(pill) {
                                    selectedPills.remove(pill)
                                    UserViewModel().deleteCategory(categoryToDelete: pill)
                                } else {
                                    selectedPills.insert(pill)
                                    UserViewModel().updateCategory(category: pill)
                                    
                                }
                            }) {
                                Text(pill)
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 8)
                                    .background(selectedPills.contains(pill) ? Color.blue : Color("Gray"))
                                    .foregroundColor(selectedPills.contains(pill) ? .white : .black)
                                    .cornerRadius(20)
                            }
                            .frame(maxWidth: .infinity, alignment: .leading)
                        }
                    }
                    .padding()
                }
            }
        }
    }
}

struct PillsButton_Previews: PreviewProvider {
    static var previews: some View {
        PillsButtonComponent(selectedPills: .constant(["Physics"]))
    }
}

