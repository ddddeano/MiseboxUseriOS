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
    associatedtype Role: Codable // Assuming Agent and Chef conform to Codable
    func onboard(userID: String) async
    var firestoreManager: FirestoreManager { get }
    var listener: ListenerRegistration? { get set }
    var role: Role { get set }
    func reset()
}

public class GenericRoleManager<RoleType: Codable>: RoleManager {
    public typealias Role = RoleType
    
    public let firestoreManager = FirestoreManager()
    public var listener: ListenerRegistration?
    @Published public var role: RoleType
    
    public init(role: RoleType) {
        self.role = role
    }
    
    public func onboard(userID: String) async {
        // Implementation for onboarding based on the role
    }
    
    public func reset() {
        listener?.remove()
        // Reset any other properties as needed
    }
}
