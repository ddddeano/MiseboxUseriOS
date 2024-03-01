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

    @StateObject var vm: ContentViewModel<RoleManagerType>

    public init(colors: [Color], miseboxUserManager: MiseboxUserManager, roleManager: RoleManagerType) {
        self.colors = colors
        self._vm = StateObject(wrappedValue: ContentViewModel(miseboxUserManager: miseboxUserManager, appRoleManager: roleManager))
    }

    public var body: some View {
        ZStack {
            GradientBackgroundView(colors: colors)
            AuthenticationView<ContentView, RoleManagerType>(vm: vm)
        }
    }
}
