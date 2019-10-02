//
//  AnalyticsManager.swift
//  AppCenterDuplicateEvents
//
//  Created by Logan Gauthier on 10/2/19.
//

import Foundation
import AppCenter
import AppCenterAnalytics

class AnalyticsManager {
    
    // MARK: - Singleton
    
    static let shared = AnalyticsManager()
    private init() {}
    
    // MARK: - Properties
    
    private lazy var appCenterPrivateKey: String = { fatalError("Set an AppCenter private key here") }()
    private let shouldAttemptToPreventDuplicates = false
    private var timer: Timer?
    
    // MARK: - Setup
    
    func setUp() {
        
        MSAppCenter.setLogLevel(.verbose)
        MSAppCenter.start(appCenterPrivateKey, withServices: [MSAnalytics.self])
        
        timer = Timer.scheduledTimer(withTimeInterval: 0.05, repeats: true) { _ in
            self.sendEvent(withName: "TimerEvent")
        }
    }
    
    // MARK: - Sending Events
    
    func sendEvent(withName eventName: String) {
        
        let eventProperties = MSEventProperties()
        eventProperties.setEventProperty(UUID().uuidString, forKey: "EventID")
        
        if shouldAttemptToPreventDuplicates {
            let eventSendingBackgroundTask = BackgroundTask(description: "Sending event named \"\(eventName)\"")
            eventSendingBackgroundTask.begin()
            DispatchQueue.main.asyncAfter(deadline: .now() + 10) {
                eventSendingBackgroundTask.end()
            }
        }
        
        MSAnalytics.trackEvent(eventName, withProperties: eventProperties, flags: .normal)
    }
}
