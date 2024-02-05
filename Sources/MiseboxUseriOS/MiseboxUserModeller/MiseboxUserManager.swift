//
//  MiseboxUserManager.swift
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore

public final class MiseboxUserManager: ObservableObject {
    public var role: SessionManager.UserRole
    
    let firestoreManager = FirestoreManager()
    let firestoreUpdateManager = FirestoreUpdateManager()
    
    public var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    
    @Published public var miseboxUser: MiseboxUser
    @Published public var miseboxUserProfile: MiseboxUserProfile
    
    public init(miseboxUser: MiseboxUser, miseboxUserProfile: MiseboxUserProfile, role: SessionManager.UserRole) {
        self.role = role
        self.miseboxUser = miseboxUser
        self.miseboxUserProfile = miseboxUserProfile
    }

    public func reset() {
        self.miseboxUser = MiseboxUser()
        self.miseboxUserProfile = MiseboxUserProfile()
        listener?.remove()
    }
    

    public enum AccountAuthenticationMethod: String {
        case anon, email, other
    }
}
public protocol CanMiseboxUser {
    var authenticationManager: AuthenticationManager { get }
    var miseboxUserManager: MiseboxUserManager { get }
    func verifyMiseboxUser(with accountType: MiseboxUserManager.AccountAuthenticationMethod) async throws
    func onboardMiseboxUser() async
}
