//
//  BackgroundTask.swift
//  AppCenterDuplicateEvents
//
//  Created by Logan Gauthier on 10/2/19.
//

import Foundation
import UIKit

class BackgroundTask {
    
    // MARK: - Properties
    
    private var identifier: UIBackgroundTaskIdentifier = .invalid
    private let description: String
    
    var isActive: Bool {
        return identifier != .invalid
    }
    
    // MARK: - Initialization
    
    init(description: String) {
        
        self.description = description
    }
    
    deinit {
        
        if identifier != .invalid {
            end()
        }
    }
    
    // MARK: - Begin/End
    
    func begin() {
        
        guard identifier == .invalid else { return }

        identifier = UIApplication.shared.beginBackgroundTask(withName: "Background Task: \(description)", expirationHandler: { [weak self] in
            self?.end()
        })
    }
    
    func end() {
        
        UIApplication.shared.endBackgroundTask(identifier)
        identifier = .invalid
    }
}
