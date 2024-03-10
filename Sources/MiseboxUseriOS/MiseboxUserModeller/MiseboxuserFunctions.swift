//
//  MiseboxUserManagerFunctions.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import MiseboxiOSGlobal
import FirebaseiOSMisebox


extension MiseboxUserManager {
    
    public func collectionListener(completion: @escaping (Result<[MiseboxUser], Error>) -> Void) {
        print("Adding collection listener for Misebox users...")
        self.listener = firestoreManager.addCollectionListener(collection: self.miseboxUser.collection, completion: completion)
    }
   
    public func updateUserInfo(provider: AuthenticationManager.AuthenticationMethod, firebaseUser: AuthenticationManager.FirebaseUser) async {
      

        if let email = firebaseUser.email, self.email.isEmpty {
            self.miseboxUser.email = email
        }

        if let photoUrl = firebaseUser.photoUrl, self.imageUrl.isEmpty {
            self.miseboxUser.imageUrl = photoUrl
        }

        if !self.accountProviders.contains(provider.rawValue) {
            self.miseboxUserProfile.accountProviders.append(provider.rawValue)
        }
    }

    private func generateHandle(provider: AuthenticationManager.AuthenticationMethod, firebaseUser: AuthenticationManager.FirebaseUser) -> String {
        var rawHandle: String = ""
        
        switch provider {
        case .email:
            if let email = firebaseUser.email, let prefix = email.components(separatedBy: "@").first {
                rawHandle = prefix
            }
        default:
            if let name = firebaseUser.name, !name.isEmpty {
                rawHandle = name
            }
        }
        
        let handle = rawHandle.replacingOccurrences(of: " ", with: "").lowercased()
        return handle
    }
    
}
