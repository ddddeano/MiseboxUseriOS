import Foundation
import FirebaseFirestore
import FirebaseiOSMisebox

extension MiseboxUserManager {
    
    public final class MiseboxUserProfile: ObservableObject, Identifiable, Listenable {
        public var doc = "misebox-user-profile"
        public var collection = "misebox-user-profiles"
        
        @Published public var id: String = ""
        @Published public var email: String = ""
        @Published public var accountProviders: [AuthenticationManager.AuthenticationMethod] = []
        @Published public var accountCreated = Date()
        @Published public var miseCODE: String = ""
        @Published public var subscription: Subscription = Subscription()
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
            email = data["email"] as? String ?? ""
            if let providerStrings = data["account_providers"] as? [String] {
                accountProviders = providerStrings.compactMap(AuthenticationManager.AuthenticationMethod.init(rawValue:))
            } else {
                accountProviders = []
            }
            miseCODE = data["miseCODE"] as? String ?? ""
            if let accountCreatedTimestamp = data["account_created"] as? Timestamp {
                self.accountCreated = accountCreatedTimestamp.dateValue()
            } else {
                self.accountCreated = Date()
            }
            
            if let rolesArray = data["roles"] as? [[String: Any]] {
                self.userRoles = rolesArray.compactMap(UserRole.init(data:))
            }
        }
        
        public func toFirestore() -> [String: Any] {
            let subscriptionData: [String: Any] = [
                "type": subscription.type.rawValue,
                "start_date": subscription.startDate,
                "end_date": subscription.endDate,
            ]
            
            let rolesData = userRoles.map { $0.toFirestore() }
            
            return [
                "id": id,
                "email": email,
                "account_providers": accountProviders.map { $0.rawValue },
                "account_created": Timestamp(date: accountCreated),
                "miseCODE": miseCODE,
                "subscription": subscriptionData,
                "userRoles": rolesData,
            ]
        }
        
        public func resetFields() {
            id = ""
            email = ""
            accountProviders = []
            accountCreated = Date()
            miseCODE = ""
            subscription = Subscription()
            userRoles = []
        }
    }
}


extension MiseboxUserManager.MiseboxUserProfile {
    
    public static var sandboxUserProfile: MiseboxUserManager.MiseboxUserProfile {
        let profile = MiseboxUserManager.MiseboxUserProfile()
        profile.id = "sandboxUserProfile123"
        profile.email = "john.doe@example.com"
        profile.accountProviders = [.email, .google, .apple] 
        profile.accountCreated = Date()
        profile.miseCODE = "MISO123456"
        profile.subscription = MiseboxUserManager.Subscription()
        profile.userRoles = [.init(role: .agent), .init(role: .miseboxUser)]
        return profile
    }
}

extension MiseboxUserManager.MiseboxUserProfile {
    var formattedAccountCreated: String {
        DateUtility.format(date: accountCreated)
    }
}
