//
//  MiseboxUserManagerProperties.swift
//  
//
//  Created by Daniel Watson on 25.01.24.
//

import Foundation
import Foundation
import FirebaseiOSMisebox

extension MiseboxUserManager {
    
    // Global Properties
    public var id: String {
        miseboxUser.id
    }

    // fullNameFormatted and nameFirstAndLast should now refer to miseboxUser.fullName
    public var fullNameFormatted: String {
        miseboxUser.fullName.formatted
    }
    
    public var nameFirstAndLast: String {
        "\(miseboxUser.fullName.first) \(miseboxUser.fullName.last)"
    }
    
    // MiseboxUser Properties
    public var handle: String {
        miseboxUser.handle
    }
    
    public var imageUrl: String {
        miseboxUser.imageUrl
    }
    
    public var verified: Bool {
        miseboxUser.verified
    }

    public var fullName: FullName {
        miseboxUser.fullName
    }
    
    // MiseboxUserProfile Properties
    public var email: String {
        miseboxUserProfile.email
    }

    public var miseCODE: String {
        miseboxUserProfile.miseCODE
    }

    public var userRoles: [UserRole] {
        miseboxUserProfile.userRoles
    }

    public var subscription: Subscription {
        miseboxUserProfile.subscription
    }

    public var accountProviders: [AuthenticationManager.AuthenticationMethod] {
        miseboxUserProfile.accountProviders
    }
}
