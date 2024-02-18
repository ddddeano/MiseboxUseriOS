import Foundation
import FirebaseiOSMisebox

extension MiseboxUserManager {
    
    func updateMiseboxUser() {
        Task {
            do {
                print("Attempting to update MiseboxUser document for user ID: \(self.miseboxUser.id)")
                await firestoreManager.updateDocument(for: self.miseboxUser)
                print("Successfully updated MiseboxUser document for user ID: \(self.miseboxUser.id)")
            }
        }
    }

    func updateMiseboxUserProfile() {
        Task {
            do {
                print("Attempting to update MiseboxUserProfile document for user ID: \(self.miseboxUserProfile.id)")
                await firestoreManager.updateDocument(for: self.miseboxUserProfile)
                print("Successfully updated MiseboxUserProfile document for user ID: \(self.miseboxUserProfile.id)")
            }
        }
    }
    
    public enum UpdateContext {
        case handle
        case miseCODE
        case email
        case imageUrl
        case verified
        case userRoles
        case fullName
        case subscription
        case accountProviders
    }
    
    public func update(contexts: [UpdateContext]) async {
        print("[MiseboxUserManager] Initiating update with contexts: \(contexts)")
        
        // Assuming both functions update the necessary fields based on the current state of `miseboxUser` and `miseboxUserProfile`
        updateMiseboxUser()
        updateMiseboxUserProfile()
        
        for context in contexts {
            print("Processing update context: \(context)")
            switch context {
            case .handle:
                print("Updated handle: \(self.miseboxUser.handle)")
            case .miseCODE:
                print("Updated miseCode: \(self.miseboxUser.miseCODE)")
            case .email:
                print("Updated email: \(self.miseboxUser.email)")
            case .imageUrl:
                print("Updated imageUrl: \(self.miseboxUser.imageUrl)")
            case .verified:
                print("Updated verified status: \(self.miseboxUser.verified)")
            case .userRoles:
                print("Updated userRoles: \(self.miseboxUser.userRoles)")
            case .fullName:
                print("Updated fullName: \(self.miseboxUserProfile.fullName)")
            case .subscription:
                print("Updated subscription: \(self.miseboxUserProfile.subscription)")
            case .accountProviders:
                print("Updated accountProviders: \(self.miseboxUserProfile.accountProviders)")
            }
        }
    }
}

