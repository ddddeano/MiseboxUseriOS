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
        // Prime the MiseboxUserProfile
        if let email = firebaseUser.email {
            self.miseboxUserProfile.email = email
        }

        // Set the photo URL or default value if not provided
        if let photoUrl = firebaseUser.photoUrl {
            self.miseboxUser.imageUrl = photoUrl
        } else {
            self.miseboxUser.imageUrl = "default_photo_url"
        }

        // Add the provider to accountProviders
        self.miseboxUserProfile.accountProviders.append(firebaseUser.provider)
        
        self.miseboxUserProfile.accountCreated = Date()

        // Prime the MiseboxUser
        self.miseboxUser.handle = await generateHandle(firebaseUser: firebaseUser)

        // Set the fullName for MiseboxUser
        self.miseboxUser.fullName.first = firebaseUser.firstName
        self.miseboxUser.fullName.last = firebaseUser.lastName
        
        // Generate and set the MiseCODE for the user profile
        self.miseboxUserProfile.miseCODE = await generateMiseCODE()
    }
    
    public func setMiseboxUserAndProfile() async throws {
        try await firestoreManager.setDoc(entity: self.miseboxUser)
        try await firestoreManager.setDoc(entity: self.miseboxUserProfile)
    }
}
