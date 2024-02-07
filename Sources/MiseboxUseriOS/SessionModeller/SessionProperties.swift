//
//  File.swift
//  
//
//  Created by Daniel Watson on 07.02.24.
//

import Foundation
extension SessionManager {
    public var id: String {
        return session.id
    }
    public var mode: String {
        session.isDarkMode ? "Dark" : "Light"
    }
}
