//
//  File.swift
//  
//
//  Created by Daniel Watson on 06.03.2024.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

public protocol ProfileSection: CaseIterable, Identifiable, Hashable, RawRepresentable where RawValue == String {
    var iconName: String { get }
    var displayName: String { get }
}

import SwiftUI
import MiseboxiOSGlobal

public class MiseboxUserProfileViewNavigation: ObservableObject {
    public enum Route: String, CaseIterable, Identifiable {
        case userInfo

        public var id: Self { self }
    }

    @MainActor @ViewBuilder
    public func router(_ route: Route) -> some View {
        switch route {
        case .userInfo:
            Text("User Info View")
        }
    }
}


