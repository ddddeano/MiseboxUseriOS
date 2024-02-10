//
//  SessionManagerFunctions.swift
//
//
//  Created by Daniel Watson on 07.02.24.
//

import Foundation
extension SessionManager {
    
    public func primeSession(firebaseUserUID: String) {
        self.session.id = firebaseUserUID
    }
    
    public func saveThemePreferences(isDarkModeEnabled: Bool) {
        UserDefaults.standard.set(isDarkModeEnabled, forKey: themePreferenceKey)
    }
}
