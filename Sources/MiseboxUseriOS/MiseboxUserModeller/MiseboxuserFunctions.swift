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
   
    public func updateUserInfo(provider: AuthenticationManager.AuthenticationMethod, firebaseUser: AuthenticationManager.FirebaseUser) async {
        print("Before update: \(self.miseboxUser.description)")

        if self.miseCODE.isEmpty {
            let newMiseCODE = await generateMiseCODE()
            print("Generated new MiseCODE: \(newMiseCODE)")
            self.miseboxUser.miseCODE = newMiseCODE
        }
        
        let generatedHandle = generateHandle(provider: provider, firebaseUser: firebaseUser)
        print("Generated Handle: \(generatedHandle)")
        self.miseboxUser.handle = generatedHandle.isEmpty ? self.miseboxUser.miseCODE : generatedHandle

        if let email = firebaseUser.email, self.email.isEmpty {
            print("Setting Email: \(email)")
            self.miseboxUser.email = email
        }

        if let photoUrl = firebaseUser.photoUrl, self.imageUrl.isEmpty {
            print("Setting Image URL: \(photoUrl)")
            self.miseboxUser.imageUrl = photoUrl
        }

        if !self.accountProviders.contains(provider.rawValue) {
            print("Adding Account Provider: \(provider.rawValue)")
            self.miseboxUserProfile.accountProviders.append(provider.rawValue)
        }

        print("After update: \(self.miseboxUser.description)")
    }

    public func generateMiseCODE() async -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var miseCODE: String
        var isUnique: Bool

        repeat {
            let randomCharacters = (0..<6).map { _ in characters.randomElement()! }
            miseCODE = "MISO" + String(randomCharacters)
            isUnique = await checkMiseCODEIsUnique(miseCODE: miseCODE)
        } while !isUnique

        return miseCODE
    }

    private func checkMiseCODEIsUnique(miseCODE: String) async -> Bool {
        do {
            // Correctly use the result of isFieldValueUnique
            return try await firestoreManager.isFieldValueUnique(inCollection: "misebox-users", fieldName: "miseCODE", fieldValue: miseCODE)
        } catch {
            // Handle error or return false indicating uniqueness check failed
            print("Error checking uniqueness of miseCODE: \(error)")
            return false
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
// Implementing Custom Description for Debugging
extension MiseboxUserManager.MiseboxUser {
    var description: String {
        """
        ID: \(id)
        Handle: \(handle)
        MiseCODE: \(miseCODE)
        Email: \(email)
        Image URL: \(imageUrl)
        Verified: \(verified)
        User Roles: \(userRoles.map { $0.description }.joined(separator: ", "))
        """
    }
}

// Assuming UserRole conforms to CustomStringConvertible for better logging
extension UserRole: CustomStringConvertible {
    var description: String {
        // Implement your description format for user roles here
        "RoleName or other identifying property"
    }
}
