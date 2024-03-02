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


public struct Misebox<ContentView: ContentViewProtocol, RoleManagerType: RoleManager>: View {
    let colors: [Color]

    @ObservedObject var miseboxUserManager: MiseboxUserManager
    let roleManager: RoleManagerType // Use the RoleManagerType generic parameter

    public init(colors: [Color], miseboxUserManager: MiseboxUserManager, roleManager: RoleManagerType) {
        self.colors = colors
        self.miseboxUserManager = miseboxUserManager
        self.roleManager = roleManager // Initialize roleManager
    }

    public var body: some View {
        ZStack {
            GradientBackgroundView(colors: colors)
            AuthenticationView<ContentView, RoleManagerType>(
                vm: ContentViewModel(
                    miseboxUserManager: miseboxUserManager,
                    roleManager: roleManager // Pass roleManager here
                )
            )
            .environmentObject(miseboxUserManager.miseboxUser)
            .environmentObject(miseboxUserManager.miseboxUserProfile)
        }
    }
}
