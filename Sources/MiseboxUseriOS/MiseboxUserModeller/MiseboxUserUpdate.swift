import Foundation
import FirebaseiOSMisebox

extension MiseboxUserManager {
    
    func updateMiseboxUser() async {
        await firestoreManager.updateDocument(for: self.miseboxUser)
    }

    func updateMiseboxUserProfile() async {
        await firestoreManager.updateDocument(for: self.miseboxUserProfile)
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
            
            var updateUser = false
            var updateProfile = false

            for context in contexts {
                print("Processing update context: \(context)")
                switch context {
                case .handle, .imageUrl, .verified, .fullName:
                    updateUser = true
                    if context == .fullName {
                        print("Updated fullName: \(self.miseboxUser.fullName)")
                    } else {
                        print("Updated \(context) in MiseboxUser")
                    }
                case .miseCODE, .email, .userRoles, .subscription, .accountProviders:
                    updateProfile = true
                    print("Updated \(context) in MiseboxUserProfile")
                }
            }

            if updateUser {
                await updateMiseboxUser()
            }

            if updateProfile {
                await updateMiseboxUserProfile()
            }
        }
    }
