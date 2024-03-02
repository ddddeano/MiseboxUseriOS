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
        if self.miseCODE.isEmpty {
            self.miseboxUser.miseCODE = await generateMiseCODE()
        }
        
        let generatedHandle = generateHandle(provider: provider, firebaseUser: firebaseUser)
        self.miseboxUser.handle = generatedHandle.isEmpty ? self.miseboxUser.miseCODE : generatedHandle

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
