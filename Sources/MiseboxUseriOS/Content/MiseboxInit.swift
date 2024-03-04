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
        
        ZStack {
            GradientBackgroundView(colors: [Env.env.appDark, Env.env.appLight])
            AuthenticationView<ContentView>(
                vm: ContentViewModel(
                    miseboxUserManager: miseboxUserManager,
                    roleManager: roleManager
                )
            )
            .environmentObject(Env.env)
            .environmentObject(miseboxUserManager.miseboxUser)
            .environmentObject(miseboxUserManager.miseboxUserProfile)
        }
    }
}

