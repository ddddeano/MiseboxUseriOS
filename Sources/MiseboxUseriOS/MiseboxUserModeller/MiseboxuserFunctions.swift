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
    // MARK: - Shared Logic Helpers
    public func updateUserInfo(provider: AuthenticationManager.AuthenticationMethod, firebaseUser: AuthenticationManager.FirebaseUser) {
        let handle = getUsername(provider: provider, firebaseUser: firebaseUser)
        
        // Generate miseCODE only if it hasn't been set yet.
        if self.miseboxUser.miseCODE.isEmpty {
            self.miseboxUser.miseCODE = generateMiseCODE()
        }
        
        if self.miseboxUser.handle.isEmpty {
            self.miseboxUser.handle = handle
        }
        if let email = firebaseUser.email, self.miseboxUser.email.isEmpty {
            self.miseboxUser.email = email
        }
        if let photoUrl = firebaseUser.photoUrl, self.miseboxUser.imageUrl.isEmpty {
            self.miseboxUser.imageUrl = photoUrl
        }
        
        if !self.miseboxUserProfile.accountProviders.contains(provider.rawValue) {
            self.miseboxUserProfile.accountProviders.append(provider.rawValue)
        }
    }

    private func generateMiseCODE() -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        return String((0..<6).map{ _ in characters.randomElement()! })
    }
    
    private func getUsername(provider: AuthenticationManager.AuthenticationMethod, firebaseUser: AuthenticationManager.FirebaseUser) -> String {
        switch provider {
        case .email:
            if let email = firebaseUser.email, let prefix = email.components(separatedBy: "@").first {
                return prefix
            }
        default:
            if let name = firebaseUser.name, !name.isEmpty {
                return name
            }
        }
        return "User"
    }
}

