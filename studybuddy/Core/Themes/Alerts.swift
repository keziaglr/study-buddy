//
//  Alerts.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 10/01/24.
//

import SwiftUI

struct Alerts {
    
    // for login register
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
    
    static func successSendEmail(action: @escaping () -> Void) -> Alert {
        Alert(
            title: Text("Success Send Reset Password Link"),
            message: Text("Please check on your registered email."),
            dismissButton: .default(Text("OK"), action: action)
        )
    }

    // for community
    static let alreadyJoined = Alert(
        title: Text("Cannot Join Community"),
        message: Text("You are already in this community"),
        dismissButton: .default(Text("OK"))
    )
    static let memberIsFull = Alert(
        title: Text("Cannot Join Community"),
        message: Text("The community already has 6 members"),
        dismissButton: .default(Text("OK"))
    )
    
    static func successJoinCommunity(action: @escaping () -> Void) -> Alert {
        Alert(
            title: Text("Success Join Community"),
            message: Text("Let's Study Together"),
            dismissButton: .default(Text("OK"), action: action)
        )
    }
    
    static func successCreateCommunity(action: @escaping () -> Void) -> Alert {
        Alert(title: Text("Success Create Community"), dismissButton: .default(Text("Yes"), action: {
            action()
        }))
    }
    
    static let fillAllFields = Alert(
        title: Text("Error"),
        message: Text("Please fill in all the fields."),
        dismissButton: .default(Text("OK"))
    )
    
    //for chatroom
    static func successLeaveCommunity(action: @escaping () -> Void) -> Alert {
        Alert(title: Text("Are You Sure?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Yes"), action: {
            action()
        }))
    }
    
    //for setschedule
    
    static func successSetSchedule(action: @escaping () -> Void) -> Alert {
        Alert(title: Text("Success Set Schedule"), dismissButton: .default(Text("Yes"), action: {
            action()
        }))
    }
    
}
