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
        @Published public var subscription = Subscription()
        @Published public var accountProviders: [String] = []
        
        public init(id: String) {
            self.id = id
        }
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            print("Initializing MiseboxUserProfile with ID: \(self.id)")
            if let fullNameData = data["full_name"] as? [String: Any] {
                print("First Name: \(fullNameData["first"] as? String ?? "N/A")")
                print("Middle Name: \(fullNameData["middle"] as? String ?? "N/A")")
                print("Last Name: \(fullNameData["last"] as? String ?? "N/A")")
            }
            if let subscriptionData = data["subscription"] as? [String: Any] {
                print("Subscription Type: \(subscriptionData["type"] as? String ?? "N/A")")
            } else {
                print("Subscription Type: N/A")
            }
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            self.fullName = fireObject(from: data["full_name"] as? [String: Any] ?? [:], using: FullName.init) ?? FullName()
            self.subscription = fireObject(from: data["subscription"] as? [String: Any] ?? [:], using: Subscription.init) ?? Subscription()
            self.accountProviders = data["account_providers"] as? [String] ?? []
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "full_name": fullName.toFirestore(),
                "subscription": subscription.toFirestore(),
                "account_providers": accountProviders
            ]
        }
        public func resetFields() {
            id = ""
            fullName = FullName()
            subscription = Subscription()
            accountProviders = []
        }
    }
}
