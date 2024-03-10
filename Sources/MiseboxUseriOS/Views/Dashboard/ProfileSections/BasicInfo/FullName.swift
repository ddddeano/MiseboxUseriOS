//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

struct FullNameProfileView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser  // Adjusted to MiseboxUser

    @State private var isEditing: Bool = false
    @State private var lastValid: MiseboxUserManager.FullName = MiseboxUserManager.FullName()

    var body: some View {
        ProfileInput(
            inputs: [
                FieldInput(title: "First Name", text: $miseboxUser.fullName.first),
                FieldInput(title: "Middle Name", text: $miseboxUser.fullName.middle),
                FieldInput(title: "Last Name", text: $miseboxUser.fullName.last)
            ],
            isEditing: $isEditing,
            onEdit: { lastValid = miseboxUser.fullName },
            onDone: { post() },
            onCancel: { miseboxUser.fullName = lastValid },
            onCheck: check
        )
    }

    private func post() {
        let result = check()
        if result.isValid {
            Task {
                await miseboxUserManager.update(contexts: [.fullName])  // Make sure this method updates the user, not the profile
            }
        } else {
            miseboxUser.fullName = lastValid
        }
    }

    private func check() -> (isValid: Bool, message: String) {
        let isValid = !miseboxUser.fullName.first.isEmpty && !miseboxUser.fullName.last.isEmpty
        return (isValid, isValid ? "" : "First and last names cannot be empty.")
    }
}
