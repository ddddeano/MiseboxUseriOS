//
// [MiseboxUseriOS.pkg] DashboardVM.swift
//
//
//  Created by Daniel Watson on 03.03.2024.
//

import Foundation

public protocol DashboardViewModelProtocol: ObservableObject {
    var miseboxUserManager: MiseboxUserManager { get }
    var miseboxUserHasNewContent: Bool { get set }
    func signOut() async
}

public class DashboardVM: DashboardViewModelProtocol, ObservableObject {
    public var miseboxUserManager: MiseboxUserManager
    @Published public var miseboxUserHasNewContent = false
    public var signOutAction: () async -> Void

    @MainActor
    public var role: String {
        miseboxUserManager.role.doc
    }

    public init(miseboxUserManager: MiseboxUserManager, signOutAction: @escaping () async -> Void) {
        self.miseboxUserManager = miseboxUserManager
        self.signOutAction = signOutAction
    }

    public func update(_ contexts: [MiseboxUserManager.UpdateContext]) async {
        Task {
            print("DashboardVM: Starting update with contexts: \(contexts)")
            await miseboxUserManager.update(contexts: contexts)
            print("DashboardVM: Completed update with contexts: \(contexts)")
        }
    }

    public func signOut() async {
        await signOutAction()
    }
}
