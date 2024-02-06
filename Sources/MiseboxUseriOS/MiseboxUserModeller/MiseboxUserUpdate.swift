import Foundation
import FirebaseiOSMisebox

extension MiseboxUserManager {

    public func updateMiseboxUser<T: Updatable>(update: T) async throws {
        try await firestoreUpdateManager.updateDocument(for: self.miseboxUser, with: update)
    }
    
    public func updateMiseboxUserProfile<T: Updatable>(update: T) async throws {
        try await firestoreUpdateManager.updateDocument(for: self.miseboxUserProfile, with: update)
    }
}
