//
//  Onboarding_MiseboxUser.swift
//  MiseboxUseriOS
//
//  Created by Daniel Watson on 10.12.23.
//

import Foundation
import MiseboxiOSGlobal
import FirebaseiOSMisebox

extension MiseboxUserManager {
    public func onboard(miseboxId: String) async {
        guard !miseboxId.isEmpty else {
            print("MiseboxUserManager [onboardMiseboxUser] Invalid or missing miseboxId.")
            return
        }

        await MainActor.run {
            self.miseboxUser.prime(id: miseboxId)
            self.miseboxUserProfile.prime(id: miseboxId)
        }
        
        do {
            let userExists = try await checkMiseboxUserExistsInFirestore()
            
            if !userExists {
                print("MiseboxUserManager [onboardMiseboxUser] User with ID \(miseboxId) not found, creating a new one...")
                try await setMiseboxUserAndProfile()
            }

            attachUserDocumentListener()
            
        } catch {
            print("MiseboxUserManager [onboardMiseboxUser] Error during onboarding: \(error.localizedDescription)")
        }
    }
    
    public func checkMiseboxUserExistsInFirestore() async throws -> Bool {
        let exists = try await firestoreManager.checkDocumentExists(collection: miseboxUser.collection, documentID: id)
        return exists
    }
    
    public func setMiseboxUserAndProfile() async throws {
           // Set the current date as the account creation date during onboarding
           let currentDate = Date()
           self.miseboxUserProfile.accountCreated = currentDate

           // Add some initializing data
           try await firestoreManager.setDoc(entity: self.miseboxUser)
           try await firestoreManager.setDoc(entity: self.miseboxUserProfile)
       }
    
    private func attachUserDocumentListener() {
        print("MiseboxUserManager [attachUserDocumentListener] Attaching document listener for user")
        documentListener(for: self.miseboxUser) { result in
            switch result {
            case .success(let updatedUser):
                DispatchQueue.main.async {
                    print("MiseboxUserManager [attachUserDocumentListener] User updated: \(updatedUser.id)")
                }
            case .failure(let error):
                print("MiseboxUserManager [attachUserDocumentListener] Error: \(error.localizedDescription)")
            }
        }

        print("MiseboxUserManager [attachUserDocumentListener] Attaching document listener for user profile")
        documentListener(for: self.miseboxUserProfile) { result in
            switch result {
            case .success(let updatedProfile):
                DispatchQueue.main.async {
                    print("MiseboxUserManager [attachUserDocumentListener] User profile updated: \(updatedProfile.id)")
                }
            case .failure(let error):
                print("MiseboxUserManager [attachUserDocumentListener] Error: \(error.localizedDescription)")
            }
        }
    }

    public func documentListener<T: Listenable>(for entity: T, completion: @escaping (Result<T, Error>) -> Void) {
        self.listener = firestoreManager.addDocumentListener(for: entity) { result in
            completion(result)
        }
    }
}
