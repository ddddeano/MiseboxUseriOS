//
//  MiseboxUserManager.swift
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore
import FirebaseiOSMisebox
import MiseboxiOSGlobal

@MainActor
public final class MiseboxUserManager: ObservableObject, RoleManager {
    public func onboard(userID: String) async {}
    
    public var role: MiseboxEcosystem.Role
    
    public let firestoreManager = FirestoreManager()
    
    public var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
        
    @Published public var miseboxUser = MiseboxUser()
    @Published public var miseboxUserProfile = MiseboxUserProfile()
    
    public init(role: MiseboxEcosystem.Role) {
        self.role = role
    }
    
    public func reset() {
        listener?.remove()
        self.miseboxUser = MiseboxUser()
        self.miseboxUserProfile = MiseboxUserProfile()
    }
}

/*public protocol CanMiseboxUser {
    var authenticationManager: AuthenticationManager { get }
    var miseboxUserManager: MiseboxUserManager { get }
     func onboardMiseboxUser() async
}*/


