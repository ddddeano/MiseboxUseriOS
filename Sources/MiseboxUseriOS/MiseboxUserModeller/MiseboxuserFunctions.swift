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
        let exists = try await firestoreManager.checkDocumentExists(collection: miseboxUser.collection, documentID: self.id)
        print("Existence check completed. Document exists: \(exists)")
        return exists
    }

    
    public func primeMiseboxUser(sessionId: String) {
        print("Priming Misebox user with session ID: \(sessionId)...")
        self.miseboxUser.id = sessionId
        if self.imageUrl.isEmpty {
            self.miseboxUser.imageUrl = defaultImage
        }
    }
    
    public func primeMiseboxUserProfile() {
        print("Priming Misebox user profile with user ID: \(self.id)...")
        self.miseboxUserProfile.id = self.id
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

