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
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    
    @State private var isEditing: Bool = false
    @State private var lastValid: MiseboxUserManager.FullName = MiseboxUserManager.FullName()
    
    var body: some View {
        ProfileInput(
            inputs: [
                FieldInput(title: "First Name", text: $miseboxUserProfile.fullName.first),
                FieldInput(title: "Middle Name", text: $miseboxUserProfile.fullName.middle),
                FieldInput(title: "Last Name", text: $miseboxUserProfile.fullName.last)
            ],
            isEditing: $isEditing,
            onEdit: { lastValid = miseboxUserProfile.fullName },
            onDone: { post() },
            onCancel: { miseboxUserProfile.fullName = lastValid },
            onCheck: check
        )
    }
    
    private func post() {
        let result = check()
        if result.isValid {
            Task {
                await miseboxUserManager.update(contexts: [.fullName])
            }
        } else {
            miseboxUserProfile.fullName = lastValid
        }
    }
    
    private func check() -> (isValid: Bool, message: String) {
        let isValid = !miseboxUserProfile.fullName.first.isEmpty && !miseboxUserProfile.fullName.last.isEmpty
        return (isValid, isValid ? "" : "First and last names cannot be empty.")
    }
}
