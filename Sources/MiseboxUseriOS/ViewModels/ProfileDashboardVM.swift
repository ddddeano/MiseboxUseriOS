//
//  File.swift
//  
//
//  Created by Daniel Watson on 24.02.2024.
//

import Foundation
import MiseboxiOSGlobal

public class ProfileDashboardVM: ObservableObject {
    public let miseboxUserManager: MiseboxUserManager
    var signOutAction: () async -> Void // Store the sign-out action

    public init(miseboxUserManager: MiseboxUserManager, signOutAction: @escaping () async -> Void) {
        self.miseboxUserManager = miseboxUserManager
        self.signOutAction = signOutAction
    }

    public func update(_ contexts: [MiseboxUserManager.UpdateContext]) async {
        Task {
            print("ProfileDashboardVM: Starting update with contexts: \(contexts)")
            
            await miseboxUserManager.update(contexts: contexts)
            print("ProfileDashboardVM: Completed update with contexts: \(contexts)")
        }
    }

    public func signOut() async {
        await signOutAction()
    }
}

public class MiseboxUserProfileViewNavigation: ObservableObject {
    public init() {}

    public enum ProfileSections: String, CaseIterable, Identifiable {
        case basicInfo = "Basic Information"
        case mediumInfo = "Medium Information"
        case advancedInfo = "Advanced Information"

        public var id: Self { self }

        public var iconName: String {
            switch self {
            case .basicInfo: return "person.fill"
            case .mediumInfo: return "calendar"
            case .advancedInfo: return "gearshape.fill"
            }
        }

        public var displayName: String { self.rawValue }
    }
}

