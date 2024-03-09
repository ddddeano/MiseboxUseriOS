//
//  MiseboxUserProfile.swift
//
//
//  Created by Daniel Watson on 26.01.24.
//

import Foundation
import FirebaseFirestore
import FirebaseiOSMisebox

extension MiseboxUserManager {
    
    public final class MiseboxUserProfile: ObservableObject, Identifiable, Listenable {
        public var doc = "misebox-user-profile"
        public var collection = "misebox-user-profiles"
        
        @Published public var id = ""
        @Published public var fullName = FullName()
        @Published public var accountProviders: [String] = []

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
            self.fullName = fireObject(from: data["full_name"] as? [String: Any] ?? [:], using: FullName.init) ?? FullName()
            self.accountProviders = data["account_providers"] as? [String] ?? []
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "full_name": fullName.toFirestore(),
                "account_providers": accountProviders
            ]
        }
        public func resetFields() {
            id = ""
            fullName = FullName()
            accountProviders = []
        }
    }
}

extension MiseboxUserManager.MiseboxUserProfile {
    public static var sandboxUserProfile: MiseboxUserManager.MiseboxUserProfile {
        let profile = MiseboxUserManager.MiseboxUserProfile()
        profile.id = "sandboxUserProfile123"
        // Setting up the fullName
        profile.fullName.first = "John"
        profile.fullName.middle = "D"
        profile.fullName.last = "Doe"
        return profile
    }
}
