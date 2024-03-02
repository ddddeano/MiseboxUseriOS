//
//  File.swift
//  MiseboxUseriOSPackage
//
//  Created by Daniel Watson on 26.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal
import Firebase
import Foundation
import FirebaseiOSMisebox
import Firebase


public struct Misebox<ContentView: ContentViewProtocol>: View {
    let colors: [Color]

    @ObservedObject var miseboxUserManager: MiseboxUserManager
    @ObservedObject var roleManager: GenericRoleManager<RoleManagerType>

    public init(colors: [Color], miseboxUserManager: MiseboxUserManager, roleManager: GenericRoleManager<RoleManagerType>) {
        self.colors = colors
        self.miseboxUserManager = miseboxUserManager
        self.roleManager = roleManager
    }

    public var body: some View {
        ZStack {
            GradientBackgroundView(colors: colors)
            AuthenticationView<ContentView, GenericRoleManager<RoleManagerType>>(
                vm: ContentViewModel(
                    miseboxUserManager: miseboxUserManager,
                    appRoleManager: roleManager
                )
            )
            .environmentObject(miseboxUserManager.miseboxUser)
            .environmentObject(miseboxUserManager.miseboxUserProfile)
        }
    }
}

