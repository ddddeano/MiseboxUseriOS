//
//  File.swift
//  
//
//  Created by Daniel Watson on 01.03.2024.
//

import Foundation
import FirebaseiOSMisebox
import Firebase

@MainActor
public protocol RoleManager: ObservableObject {
    func onboard(userID: String) async
    var firestoreManager: FirestoreManager { get }
    var listener: ListenerRegistration? { get set }
    func reset()
}

public class GenericRoleManager<RoleType: RoleManager>: ObservableObject {

    public let firestoreManager = FirestoreManager()
    public var listener: ListenerRegistration?
    @Published public var chefOrAgentManager: RoleType
    
    public init(chefOrAgentManager: RoleType) {
        self.chefOrAgentManager = chefOrAgentManager
    }
    
    /*public func onboard(userID: String) async {
        // Implementation for onboarding based on the role
        try? await chefOrAgentManager.onboard(userID: userID)
    }*/
    
    public func reset() {
        listener?.remove()
        // Reset any other properties as needed
    }
}


