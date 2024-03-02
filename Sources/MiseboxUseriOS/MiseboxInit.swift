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


public struct Misebox<ContentView: ContentViewProtocol>: View where ContentView.RoleManagerType: RoleManager {
    let colors: [Color]
    @ObservedObject var miseboxUserManager: MiseboxUserManager
    var roleManager: ContentView.RoleManagerType

    public init(colors: [Color], miseboxUserManager: MiseboxUserManager, roleManager: ContentView.RoleManagerType) {
        self.colors = colors
        self.miseboxUserManager = miseboxUserManager
        self.roleManager = roleManager
    }

    public var body: some View {
        ZStack {
            GradientBackgroundView(colors: colors)
            AuthenticationView<ContentView>(
                vm: ContentViewModel(
                    miseboxUserManager: miseboxUserManager,
                    roleManager: roleManager
                )
            )
            .environmentObject(miseboxUserManager.miseboxUser)
            .environmentObject(miseboxUserManager.miseboxUserProfile)
        }
    }
}


