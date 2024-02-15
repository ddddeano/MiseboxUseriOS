import Foundation
import FirebaseiOSMisebox

extension MiseboxUserManager {
    
    func updateMiseboxUser() {
        Task {
            do {
                await firestoreManager.updateDocument(for: self.miseboxUser)
            }
        }
    }

    func updateMiseboxUserProfile() {
        Task {
            do {
                await firestoreManager.updateDocument(for: self.miseboxUserProfile)
            }
        }
    }

    
    public enum UpdateContext {
        case username
        case miseCODE
        case email
        case imageUrl
        case verified
        case userRoles
        case fullName
        case subscription
        case accountProviders
    }
    
    public func update(context: UpdateContext) async {
        switch context {
        case .username:
            print("Current username: \(self.miseboxUser.username)")
            updateMiseboxUser()
        case .miseCODE:
            print("Current miseCode: \(self.miseboxUser.miseCODE)")
            updateMiseboxUser()
        case .email:
            print("Current email: \(self.miseboxUser.email)")
            updateMiseboxUser()
        case .imageUrl:
            print("Current imageUrl: \(self.miseboxUser.imageUrl)")
            updateMiseboxUser()
        case .verified:
            print("Current verified status: \(self.miseboxUser.verified)")
            updateMiseboxUser()
        case .userRoles:
            print("Current userRoles: \(self.miseboxUser.userRoles)")
            updateMiseboxUser()
        case .fullName:
            print("Current fullName: \(self.miseboxUserProfile.fullName)")
            updateMiseboxUserProfile()
        case .subscription:
            print("Current subscription: \(self.miseboxUserProfile.subscription)")
            updateMiseboxUserProfile()
        case .accountProviders:
            print("Current accountProviders: \(self.miseboxUserProfile.accountProviders)")
            updateMiseboxUserProfile()
        }
    }
}

