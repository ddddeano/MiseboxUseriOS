//
//  File.swift
//  MiseboxiOSPackage
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Combine


extension SessionManager {
    
    public class Session: ObservableObject {
        public let role: MiseboxUserManager.Role
        @Published public var id = ""
        @Published public var isDarkMode = false
        
        public init(role: MiseboxUserManager.Role) {
            self.role = role
        }
    }
}

