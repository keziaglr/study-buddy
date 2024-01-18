//
//  Alerts.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import SwiftUI

struct Alerts {
    static let incorrectPassword = Alert(
        title: Text("Incorrect Password"),
        message: Text("The password you entered is not same with password confirmation. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let errorRegister = Alert(
        title: Text("Register Error"),
        message: Text("The email is not valid. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let invalidCredentials = Alert(
        title: Text("Invalid Credentials"),
        message: Text("The email or password is not valid. Please try again."),
        dismissButton: .default(Text("OK"))
    )
    
    static let memberIsFull = Alert(
        title: Text("Cannot Join Community"),
        message: Text("The community already has 6 members"),
        dismissButton: .default(Text("OK"))
    )
    
    static let successLeaveCommunity = Alert(
        title: Text("Success Leave Community"),
        message: Text("Bye Buddy"),
        dismissButton: .default(Text("OK"))
    )
    
    static let successJoinCommunity = Alert(
        title: Text("Success Join Community"),
        message: Text("Let's Study Together"),
        dismissButton: .default(Text("OK"))
    )
    
    static let successCreateCommunity = Alert(
        title: Text("Success Create Community"),
        message: Text("Find Your Buddies"),
        dismissButton: .default(Text("OK"))
    )
    
    static let fillAllFields = Alert(
        title: Text("Error"),
        message: Text("Please fill in all the fields."),
        dismissButton: .default(Text("OK"))
    )
    
}
