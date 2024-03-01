//
//  File.swift
//  
//
//  Created by Daniel Watson on 29.02.2024.
//

import Foundation
import FirebaseiOSMisebox
import MiseboxiOSGlobal

import Foundation
import FirebaseFirestore

extension MiseboxUserManager {
    public static func checkUserHasRole(userID: String, role: MiseboxEcosystem.Role, completion: @escaping (Bool, Error?) -> Void) {
        let collection = "misebox-users"
        // Use StaticFirestoreManager to reference the document
        let documentRef = StaticFirestoreManager.documentReference(forCollection: collection, documentID: userID)
        
        documentRef.getDocument { (document, error) in
            if let error = error {
                // Handle the error
                completion(false, error)
                return
            }
            
            guard let document = document, document.exists,
                  let userRolesData = document.data()?["user_roles"] as? [[String: Any]] else {
                // Document does not exist or does not contain the "user_roles" field
                completion(false, StaticFirestoreManager.FirestoreError.documentNotFound)
                return
            }
            
            let userRoles = userRolesData.compactMap { UserRole(data: $0) }
            let hasRole = userRoles.contains { $0.role.doc == role.doc }
            completion(hasRole, nil)
        }
    }
}

