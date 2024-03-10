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
        @Published public var accountCreated: Date
        
        public init() {
            self.accountCreated = Date()
        }
        
        public func prime(id: String) {
            self.id = id
        }
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data(),
                  let accountCreatedTimestamp = data["account_created"] as? Timestamp else { return nil }
            
            self.id = documentSnapshot.documentID
            self.accountCreated = accountCreatedTimestamp.dateValue()
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
            self.fullName = fireObject(from: data["full_name"] as? [String: Any] ?? [:], using: FullName.init) ?? FullName()
            self.accountProviders = data["account_providers"] as? [String] ?? []
            if let accountCreatedTimestamp = data["account_created"] as? Timestamp {
                self.accountCreated = accountCreatedTimestamp.dateValue()
            } else {
                self.accountCreated = Date()
            }
        }
        
        public func toFirestore() -> [String: Any] {
            [
                "full_name": fullName.toFirestore(),
                "account_providers": accountProviders,
                "account_created": Timestamp(date: accountCreated)
            ]
        }
        
        public func resetFields() {
            id = ""
            fullName = FullName()
            accountProviders = []
            accountCreated = Date()
        }
    }
}
extension MiseboxUserManager.MiseboxUserProfile {
    
    public static var sandboxUserProfile: MiseboxUserManager.MiseboxUserProfile {
        let profile = MiseboxUserManager.MiseboxUserProfile()
        profile.id = "sandboxUserProfile123"
        profile.fullName.first = "John"
        profile.fullName.middle = "D"
        profile.fullName.last = "Doe"
        profile.accountCreated = DateUtility.createDate(year: 2023, month: 4, day: 12) 
        return profile
    }
}

extension MiseboxUserManager.MiseboxUserProfile {
    var formattedAccountCreated: String {
        DateUtility.format(date: accountCreated)
    }
}
