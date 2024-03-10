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
    
    public func onboard(firebaseUser: AuthenticationManager.FirebaseUser) async {
         guard !firebaseUser.uid.isEmpty else {
             print("MiseboxUserManager [onboardUser] Invalid or missing Firebase UID.")
             return
         }

         await MainActor.run {
             self.miseboxUser.prime(id: firebaseUser.uid)
             self.miseboxUserProfile.prime(id: firebaseUser.uid)
         }

         do {
             let userExists = try await checkMiseboxUserExistsInFirestore()
             if !userExists {
                 print("MiseboxUserManager [onboardUser] User with ID \(firebaseUser.uid) not found, creating a new one...")
                 try await setMiseboxUserAndProfile()
             }
             attachUserDocumentListener()
         } catch {
             print("MiseboxUserManager [onboardUser] Error during onboarding: \(error.localizedDescription)")
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
