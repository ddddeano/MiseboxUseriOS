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

           print("MiseboxUserManager [onboardMiseboxUser] Priming user and profile with miseboxId: \(miseboxId)")
           await MainActor.run {
               self.miseboxUser.prime(id: miseboxId)
               self.miseboxUserProfile.prime(id: miseboxId)
           }
        
        do {
            let userExists = try await checkMiseboxUserExistsInFirestore()
            print("MiseboxUserManager [onboardMiseboxUser] Does user exist? \(userExists)")
            
            if userExists {
                print("MiseboxUserManager [onboardMiseboxUser] User exists, attaching document listener.")
                attachUserDocumentListener()
            } else {
                print("MiseboxUserManager [onboardMiseboxUser] User with ID \(id) not found, creating a new one...")
                try await setMiseboxUserAndProfile()
                print("MiseboxUserManager [onboardMiseboxUser] New user and profile created, attaching document listener.")
                attachUserDocumentListener()
            }
        } catch {
            print("MiseboxUserManager [onboardMiseboxUser] Error during onboarding: \(error.localizedDescription)")
        }
    }


    private func attachUserDocumentListener() {
        documentListener(for: self.miseboxUser) { result in
            switch result {
            case .success(let updatedUser):
                DispatchQueue.main.async {
                    print("MiseboxUserManager [attachUserDocumentListener] User updated: \(updatedUser.id)")
                    // Here, you can add additional logic to handle the updated user data
                }
            case .failure(let error):
                print("MiseboxUserManager [attachUserDocumentListener] Error: \(error.localizedDescription)")
            }
        }
    }
    
    public func checkMiseboxUserExistsInFirestore() async throws -> Bool {
        guard !id.isEmpty else {
            print("MiseboxUserManager [checkMiseboxUserExistsInFirestore] ID is empty.")
            return false
        }
        let exists = try await firestoreManager.checkDocumentExists(collection: miseboxUser.collection, documentID: id)
        print("MiseboxUserManager [checkMiseboxUserExistsInFirestore] Document exists = \(exists) for ID: \(id)")
        return exists
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
    
    // Add any other necessary methods...
}
