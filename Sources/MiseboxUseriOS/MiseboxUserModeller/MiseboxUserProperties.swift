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
        [fullName.first, fullName.middle, fullName.last].filter { !$0.isEmpty }.joined(separator: " ")
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
    
    // EcoSystem Properties
    
    public var miseboxUserMotto: String {
        ecosystemData?.miseboxUserMotto ?? ""
    }
    
    public var chefMotto: String {
        ecosystemData?.chefMotto ?? ""
    }
    
    public var agentMotto: String {
        ecosystemData?.agentMotto ?? ""
    }
    
    public var recruiterMotto: String {
        ecosystemData?.recruiterMotto ?? ""
        
    }
}
