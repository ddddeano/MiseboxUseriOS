//
//  HandleProfileView.swift
//
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal



struct HandleProfileView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser

    @State private var isEditing: Bool = false
    @State private var lastValid: String = ""
    @State private var validationResult: (isValid: Bool, message: String) = (true, "")

    var body: some View {
     
            VStack {
                ProfileInput(
                    inputs: [FieldInput(title: "Handle", text: $miseboxUser.handle)],
                    isEditing: $isEditing,
                    onEdit: { lastValid = miseboxUser.handle},
                    onDone: { post() },
                    onCancel: { miseboxUser.handle = lastValid },
                    onCheck: check
                )
            }
        }
    
    private func post() {
        let result = check()
        if result.isValid {
            Task {
                await miseboxUserManager.update(contexts: [.handle])
            }
        } else {
            miseboxUser.handle = lastValid
        }
    }

    private func check() -> (isValid: Bool, message: String) {
        if miseboxUser.handle.isEmpty {
            return (false, "Handle cannot be empty.")
        }

        // Placeholder for a more complex uniqueness check
        let isUnique = true  // Replace with actual check
        if !isUnique {
            return (false, "Handle must be unique.")
        }

        return (true, "")
    }
}
