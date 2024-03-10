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
    
    public func authoring(firebaseUser: AuthenticationManager.FirebaseUser) async {
        guard !firebaseUser.uid.isEmpty else {
            print("MiseboxUserManager [authoring] Invalid or missing miseboxId.")
            return
        }
        
        await MainActor.run {
            self.miseboxUser.prime(id: firebaseUser.uid)
            self.miseboxUserProfile.prime(id: firebaseUser.uid)
        }
        
        await primeNewUserAndProfile(firebaseUser: firebaseUser)
        
        await onboard(miseboxId: firebaseUser.uid)
    }

    
    public func onboard(miseboxId: String) async {
       
        do {
            let userExists = try await checkMiseboxUserExistsInFirestore()
            if !userExists {
                print("MiseboxUserManager [onboard] User with ID \(miseboxId) not found, creating a new one...")
                try await setMiseboxUserAndProfile()
            }
            attachUserDocumentListener()
        } catch {
            print("MiseboxUserManager [onboard] Error during onboarding: \(error.localizedDescription)")
        }
    }
    
    public func checkMiseboxUserExistsInFirestore() async throws -> Bool {
        let exists = try await firestoreManager.checkDocumentExists(collection: miseboxUser.collection, documentID: id)
        return exists
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
