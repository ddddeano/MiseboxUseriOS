//
//  MiseboxUser_Creation.swift
//
//
//  Created by Daniel Watson on 10.03.2024.
//

import Foundation
import MiseboxiOSGlobal
import FirebaseiOSMisebox
extension MiseboxUserManager {
    
    public func primeNewUserAndProfile(firebaseUser: AuthenticationManager.FirebaseUser) async {
        // Generate and set the MiseCODE
        self.miseboxUser.miseCODE = await generateMiseCODE()
        
        // Set the handle
        self.miseboxUser.handle = await generateHandle(firebaseUser: firebaseUser)
        
        // Set the email if available
        if let email = firebaseUser.email {
            self.miseboxUser.email = email
        }
        
        // Set the photo URL or default value if not provided
        if let photoUrl = firebaseUser.photoUrl {
            self.miseboxUser.imageUrl = photoUrl
        } else {
            self.miseboxUser.imageUrl = "default_photo_url"
        }

        self.miseboxUserProfile.accountProviders.append(firebaseUser.provider.rawValue)
        
        self.miseboxUserProfile.accountCreated = Date()
        
        self.miseboxUserProfile.fullName.first = firebaseUser.firstName
        self.miseboxUserProfile.fullName.last = firebaseUser.lastName

    }
    
    public func setMiseboxUserAndProfile() async throws {
        try await firestoreManager.setDoc(entity: self.miseboxUser)
        try await firestoreManager.setDoc(entity: self.miseboxUserProfile)
    }
}
