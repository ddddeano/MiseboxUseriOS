//
//  MiseboxUserManagerFunctions.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import GlobalMiseboxiOS
import FirebaseiOSMisebox


extension MiseboxUserManager {
    
    public func checkMiseboxUserExistsInFirestore() async throws -> Bool {
        print("Checking if Misebox user exists in Firestore... Collection: '\(miseboxUser.collection)', Document ID: '\(self.id)'")

        guard !self.id.isEmpty else {
            print("Document ID is empty. Cannot proceed with checking document existence in Firestore.")
            return false
        }

        let exists = try await firestoreManager.checkDocumentExists(collection: miseboxUser.collection, documentID: self.id)
        print("Existence check completed. Document exists: \(exists)")
        return exists
    }


    public func primeMiseboxUser(id: String) {
        print("Before priming Misebox user, current user ID: \(self.miseboxUser.id)")
        print("Priming Misebox user with session ID: \(id)...")
        self.miseboxUser.prime(id: id)
       /* not sure what to do with image yet we can wit if self.imageUrl.isEmpty {
            self.miseboxUser.imageUrl = defaultImage
        }*/
        print("After priming Misebox user, new user ID: \(self.miseboxUser.id)")
    }

    public func primeMiseboxUserProfile(id: String) {
        print("Before priming Misebox user profile, current profile ID: \(self.miseboxUserProfile.id)")
        print("Priming Misebox user profile with user ID: \(id)...")
        self.miseboxUserProfile.prime(id: id)
        print("After priming Misebox user profile, new profile ID: \(self.miseboxUserProfile.id)")
    }
    
    public func setMiseboxUserAndProfile() async throws {
        print("Setting Misebox user and profile in Firestore...")
        try await firestoreManager.setDoc(entity: self.miseboxUser)
        try await firestoreManager.setDoc(entity: self.miseboxUserProfile)
    }
    
    public func documentListener<T: Listenable>(for entity: T, completion: @escaping (Result<T, Error>) -> Void) {
        print("Adding document listener for \(T.self)...")
        self.listener = firestoreManager.addDocumentListener(for: entity) { result in
            completion(result)
        }
    }
    
    public func collectionListener(completion: @escaping (Result<[MiseboxUser], Error>) -> Void) {
        print("Adding collection listener for Misebox users...")
        self.listener = firestoreManager.addCollectionListener(collection: self.miseboxUser.collection, completion: completion)
    }
}

