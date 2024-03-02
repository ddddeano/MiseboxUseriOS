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
    var firestoreManager: FirestoreManager { get }
    var listener: ListenerRegistration? { get set }
    
    func onboard(userID: String) async
    func reset()
}


