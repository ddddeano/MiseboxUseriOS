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
        
        // Set the photo URL
        if let photoUrl = firebaseUser.photoUrl {
            self.miseboxUser.imageUrl = photoUrl
        } else {
            // Set a default photo URL if none provided
            self.miseboxUser.imageUrl = "default_photo_url"
        }
        
        // Set the current date as the account creation date during onboarding
        self.miseboxUserProfile.accountCreated = Date()
    }
    
    public func setMiseboxUserAndProfile() async throws {
        try await firestoreManager.setDoc(entity: self.miseboxUser)
        try await firestoreManager.setDoc(entity: self.miseboxUserProfile)
    }
}
