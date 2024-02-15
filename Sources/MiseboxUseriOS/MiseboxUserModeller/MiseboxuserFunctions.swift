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
        guard !self.id.isEmpty else {
            print("MiseboxUserManager checkMiseboxUserExistsInFirestore: ID is empty.")
            return false
        }
        let exists = try await firestoreManager.checkDocumentExists(collection: miseboxUser.collection, documentID: self.id)
        print("MiseboxUserManager checkMiseboxUserExistsInFirestore: Document exists = \(exists) for ID: \(self.id)")
        return exists
    }


    public func primeMiseboxUser(id: String) {
        self.miseboxUser.prime(id: id)
       /* not sure what to do with image yet we can wit if self.imageUrl.isEmpty {
            self.miseboxUser.imageUrl = defaultImage
        }*/
    }

    public func primeMiseboxUserProfile(id: String) {
        self.miseboxUserProfile.prime(id: id)
    }
    
    public func setMiseboxUserAndProfile() async throws {
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

