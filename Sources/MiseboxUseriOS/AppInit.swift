//
//  File.swift
//  MiseboxUseriOSPackage
//
//  Created by Daniel Watson on 26.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

public struct Misebox<ContentView: ContentViewProtocol>: View {
    let colors: [Color]
    @ObservedObject var miseboxUserManager: MiseboxUserManager
    
    public init(colors: [Color], miseboxUserManager: MiseboxUserManager, @ViewBuilder contentViewFactory: @escaping () -> ContentView) {
        self.colors = colors
        self.miseboxUserManager = miseboxUserManager
    }
    
    public var body: some View {
        ZStack {
            GradientBackgroundView(colors: colors)
           /* AuthenticationView<ContentView: ContentViewProtocol>(ContentViewModel(miseboxUserManager: miseboxUserManager))
                .environmentObject(miseboxUserManager.miseboxUser)
                .environmentObject(miseboxUserManager.miseboxUserProfile)*/
        }
    }
}

