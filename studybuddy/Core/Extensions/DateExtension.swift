//
//  DateExtension.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 21/01/24.
//

import Foundation

extension Date {
    func dateFormat() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "ddMMyyyy"
        return dateFormatter.string(from: self).capitalized

    }
    func onlyHourMinute() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        return dateFormatter.string(from: self).capitalized

    }
}
