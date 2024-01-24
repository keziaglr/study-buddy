//
//  EventStoreManager.swift
//  studybuddy
//
//  Created by Eric Prasetya Sentosa on 24/01/24.
//

import Foundation
import EventKit

@MainActor
class EventStoreManager: ObservableObject {
    @Published var eventStore: EKEventStore
    @Published var authorizationStatus: EKAuthorizationStatus
    static let shared = EventStoreManager()
    
    init() {
        eventStore = EKEventStore()
        authorizationStatus =  EKEventStore.authorizationStatus(for: .event)
    }
    
    func setupEventStore() async throws {
        _ = try await verifyAuthorizationStatus()
       authorizationStatus = EKEventStore.authorizationStatus(for: .event)
    }
    
    private func requestFullAccess() async throws -> Bool {
        if #available(iOS 17.0, *) {
            return try await eventStore.requestFullAccessToEvents()
        } else {
            // Fall back on earlier versions.
            return try await eventStore.requestAccess(to: .event)
        }
    }
    
    func verifyAuthorizationStatus() async throws -> Bool {
        let status = EKEventStore.authorizationStatus(for: .event)
        switch status {
        case .notDetermined:
            return try await requestFullAccess()
        case .restricted:
            throw EventStoreError.restricted
        case .denied:
            throw EventStoreError.denied
        case .fullAccess:
            return true
        case .writeOnly:
            throw EventStoreError.upgrade
        @unknown default:
            throw EventStoreError.unknown
        }
    }
    
    func addEvent(event: EKEvent) throws {
        event.calendar = eventStore.defaultCalendarForNewEvents
        try eventStore.save(event, span: .thisEvent)
    }
}

enum EventStoreError: Error {
    case denied
    case restricted
    case unknown
    case upgrade
    case notDetermined
}

extension EventStoreError: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .denied:
            return NSLocalizedString("The app doesn't have permission to Calendar in Settings.", comment: "Access denied")
         case .restricted:
            return NSLocalizedString("This device doesn't allow access to Calendar.", comment: "Access restricted")
        case .unknown:
            return NSLocalizedString("An unknown error occured.", comment: "Unknown error")
        case .upgrade:
            let access = "The app has write-only access to Calendar in Settings."
            let update = "Please grant it full access so the app can fetch and delete your events."
            return NSLocalizedString("\(access) \(update)", comment: "Upgrade to full access")
        case .notDetermined:
            return NSLocalizedString("The access has not been determined", comment: "Access not determined")
        }
    }
}
