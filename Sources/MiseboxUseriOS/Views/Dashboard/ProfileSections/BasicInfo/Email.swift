//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import SwiftUI
import MiseboxiOSGlobal

struct EmailProfileView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @State private var isEditing: Bool = false
    @State private var lastValid: String = ""

    var body: some View {
        ProfileInput(
            inputs: [FieldInput(title: "Email", text: $miseboxUser.email)],
            isEditing: $isEditing,
            onEdit: { lastValid = miseboxUser.email },
            onDone: { post() },
            onCancel: { miseboxUser.email = lastValid },
            onCheck: check
        )
    }

    private func post() {
        let result = check()
        if result.isValid {
            Task {
                await miseboxUserManager.update(contexts: [.email])
            }
        } else {
            miseboxUser.email = lastValid
        }
    }

    private func check() -> (isValid: Bool, message: String) {
        if miseboxUser.email.isEmpty {
            return (false, "Email cannot be empty.")
        }
        
        if !miseboxUser.email.contains("@") {
            return (false, "Email must contain an '@' symbol.")
        }

        return (true, "")
    }
}
