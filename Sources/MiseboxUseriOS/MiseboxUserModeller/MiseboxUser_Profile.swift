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
        @Published public var accountCreated: Date?  
        
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
            if let accountCreatedTimestamp = data["account_created"] as? Timestamp {
                self.accountCreated = accountCreatedTimestamp.dateValue()
            }
        }
        
        public func toFirestore() -> [String: Any] {
            var firestoreData: [String: Any] = [
                "full_name": fullName.toFirestore(),
                "account_providers": accountProviders
            ]
            if let accountCreated = accountCreated {
                firestoreData["account_created"] = Timestamp(date: accountCreated)
            }
            return firestoreData
        }
        
        public func resetFields() {
            id = ""
            fullName = FullName()
            accountProviders = []
            accountCreated = nil  // Reset the account creation date
        }
    }
    
    public static var sandboxUserProfile: MiseboxUserManager.MiseboxUserProfile {
        let profile = MiseboxUserManager.MiseboxUserProfile()
        profile.id = "sandboxUserProfile123"
        profile.fullName.first = "John"
        profile.fullName.middle = "D"
        profile.fullName.last = "Doe"
        
        // Use the utility function to set a specific date
        profile.accountCreated = createDate(year: 2023, month: 4, day: 12)
        
        return profile
    }
}
