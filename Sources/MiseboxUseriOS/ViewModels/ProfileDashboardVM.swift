//
//  File.swift
//  
//
//  Created by Daniel Watson on 24.02.2024.
//

import Foundation
import MiseboxiOSGlobal

public class ProfileDashboardVM: ObservableObject {
    let miseboxUserManager: MiseboxUserManager

    var signOutAction: () async -> Void // Store the sign-out action

   public init(miseboxUserManager: MiseboxUserManager, signOutAction: @escaping () async -> Void) {
        self.miseboxUserManager = miseboxUserManager
        self.signOutAction = signOutAction
    }

    func update(_ contexts: [MiseboxUserManager.UpdateContext]) async {
        Task {
            print("ProfileDashboardVM: Starting update with contexts: \(contexts)")
            
            await miseboxUserManager.update(contexts: contexts)
            print("ProfileDashboardVM: Completed update with contexts: \(contexts)")
        }
    }
    func signOut() async {
        await signOutAction()
    }
}

class MiseboxUserProfileViewNavigation: ObservableObject {

    enum ProfileSections: String, NavigationSection {
        case basicInfo = "Basic Information"
        case mediumInfo = "Medium Information"
        case advancedInfo = "Advanced Information"

        var id: Self { self }

        var iconName: String {
            switch self {
            case .basicInfo: return "person.fill"
            case .mediumInfo: return "calendar"
            case .advancedInfo: return "gearshape.fill"
            }
        }
        var displayName: String { self.rawValue }
    }
}
