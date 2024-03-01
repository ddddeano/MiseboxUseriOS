//
//  File.swift
//  MiseboxUseriOSPackage
//
//  Created by Daniel Watson on 26.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

import SwiftUI
import MiseboxiOSGlobal

public struct Misebox<ContentView: ContentViewProtocol>: View {
    let colors: [Color]
    @ObservedObject var vm: ContentViewModel
    
    public init(colors: [Color], vm: ContentViewModel) {
        self.colors = colors
        self.vm = vm
    }
    
    public var body: some View {
        ZStack {
            GradientBackgroundView(colors: colors)
            AuthenticationView<ContentView>(vm: vm)
        }
    }
}

