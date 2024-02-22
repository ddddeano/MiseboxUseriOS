//
//  MiseboxUserManagerProperties.swift
//  
//
//  Created by Daniel Watson on 25.01.24.
//

import Foundation
extension MiseboxUserManager {
    
    // Global Properties
    public var id: String {
        miseboxUser.id
    }
    public var name: String {
        fullName.first
    }
    public var fullNameFormatted: String {
        fullName.formatted
    }
    
    // MiseboxUser Properties
    
    public var email: String {
        miseboxUser.email
    }
    public var handle: String {
        miseboxUser.handle
    }
    
    public var imageUrl: String {
        miseboxUser.imageUrl
    }
    
    public var miseCODE: String {
        miseboxUser.miseCODE
    }
    
    public var verified: Bool {
        miseboxUser.verified
    }
    
    public var userRoles: [UserRole] {
        miseboxUser.userRoles
    }
    // MiseboxUserProfile Properties
    
    public var fullName: FullName {
        miseboxUserProfile.fullName
    }
    
    public var accountProviders: [String] {
        miseboxUserProfile.accountProviders
    }
    
    public var subscription: Subscription {
        miseboxUserProfile.subscription
    }
}
