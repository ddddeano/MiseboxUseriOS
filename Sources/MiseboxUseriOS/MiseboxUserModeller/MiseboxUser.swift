//
//  MiseboxUser.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore
import FirebaseiOSMisebox
import MiseboxiOSGlobal

extension MiseboxUserManager {
    public final class MiseboxUser: ObservableObject, Identifiable, Listenable {
        
        public let doc = "misebox-user"
        public let collection = "misebox-users"
        
        @Published public var id: String = ""
        
        @Published public var handle: String = ""
        @Published public var miseCODE: String = ""
        @Published public var email: String = ""
        @Published public var imageUrl: String = ""
        @Published public var verified: Bool = false
        @Published public var userRoles: [UserRole] = []
        
        public init() {}
        
        public func prime(id: String) {
                self.id = id
        }
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            handle = data["handle"] as? String ?? ""
            email = data["email"] as? String ?? ""
            miseCODE = data ["misecode"] as? String ?? ""
            imageUrl = data["image_url"] as? String ?? defaultImage
            verified = data["verified"] as? Bool ?? false
            
            if let rolesData = data["user_roles"] as? [[String: Any]] {
                userRoles = rolesData.compactMap(UserRole.init)
            }
        }
        
        public func toFirestore() -> [String: Any] {
            return [
                "handle": handle,
                "email": email,
                "misecode": miseCODE,
                "image_url": imageUrl,
                "verified": verified,
                "user_roles": userRoles.map { $0.toFirestore() }
            ]
        }
        public func resetFields() {
            id = ""
            handle = ""
            email = ""
            miseCODE = ""
            imageUrl = defaultImage
            verified = false
            userRoles = []
        }
    }
}

extension MiseboxUserManager.MiseboxUser {
    public static var sandboxUser: MiseboxUserManager.MiseboxUser {
        let user = MiseboxUserManager.MiseboxUser()
        user.id = "sandboxUser123"
        user.handle = "johnDoe"
        user.miseCODE = "MISE1234"
        user.email = "john.doe@example.com"
        user.imageUrl = "https://i.pravatar.cc/300"
        user.verified = true
        user.userRoles = [.init(role: .miseboxUser), .init(role: .agent)]
        return user
    }
}


