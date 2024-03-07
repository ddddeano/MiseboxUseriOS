//
//  File.swift
//  MiseboxUseriOSPackage
//
//  Created by Daniel Watson on 26.02.2024.
//

import SwiftUI
import MiseboxiOSGlobal
import FirebaseiOSMisebox
import Firebase

public struct Misebox<ContentView: ContentViewProtocol>: View where ContentView.RoleManagerType: RoleManager {
    @ObservedObject var miseboxUserManager: MiseboxUserManager
    var roleManager: ContentView.RoleManagerType?

    public init(miseboxUserManager: MiseboxUserManager, roleManager: ContentView.RoleManagerType? = nil) {
        self.miseboxUserManager = miseboxUserManager
        self.roleManager = roleManager
        let role = miseboxUserManager.role
        Env.env.mode = .development
        Env.env.welcome = role.welcome
        Env.env.motto = role.motto
        Env.env.smallPrint = role.smallPrint
        Env.env.appDark = role.appDark
        Env.env.appLight = role.appLight
    }

    public var body: some View {
        //
        ZStack {
            GradientBackgroundView(colors: [Env.env.appDark, Env.env.appLight])
            AuthenticationView<ContentView>(
                cvm: ContentViewModel(
                    miseboxUserManager: miseboxUserManager,
                    roleManager: roleManager
                )
            )
            .environmentObject(miseboxUserManager.miseboxUser)
            .environmentObject(miseboxUserManager.miseboxUserProfile)
        }
    }
}

public class NoRoleManager: ObservableObject, RoleManager {
    public var firestoreManager = FirestoreManager()
    public var listener: ListenerRegistration?
    
    public init() {}
    
    public func onboard(miseboxId: String) async {
        // Implementation for no specific role
    }
    
    public func reset() {
        // Reset or clear data if necessary
    }
}
