//
//  File.swift
//  
//
//  Created by Daniel Watson on 26.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

struct Misebox: View {
    let colors: [Color]
    @ObservedObject var miseboxUserManager: MiseboxUserManager

    public init(colors: [Color], miseboxUserManager: MiseboxUserManager) {
          self.colors = colors
          self.miseboxUserManager = miseboxUserManager
      }
    
   public var body: some View {
        ZStack {
            GradientBackgroundView(colors: colors)
     /*       AuthenticationView(vm: ContentViewModel(miseboxUserManager: miseboxUserManager))
                .environmentObject(miseboxUserManager.miseboxUser)
                .environmentObject(miseboxUserManager.miseboxUserProfile)*/
        }
    }
}
