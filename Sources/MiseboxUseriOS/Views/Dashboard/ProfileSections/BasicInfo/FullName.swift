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
    @State private var isValid: Bool = true
    @State private var isEditing: Bool = false
    @State private var lastValidName: MiseboxUserManager.FullName = .init()

    var body: some View {
        VStack {
            if !isEditing {
                Text(miseboxUserProfile.fullName.formatted)
                    .displayValid(backgroundColor: .purple.opacity(0.1), borderColor: .purple)
            } else {
                VStack {
                    TextField("First Name", text: $miseboxUserProfile.fullName.first)
                        .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                    TextField("Middle Name", text: $miseboxUserProfile.fullName.middle)
                        .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                    TextField("Last Name", text: $miseboxUserProfile.fullName.last)
                        .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                }
                .onChange(of: miseboxUserProfile.fullName) { _ in
                    checkValidity()
                }
            }
            Spacer()
            EditToggleImageButton(
                isEditing: $isEditing,
                isValid: isValid,
                onEdit: {
                    lastValidName = miseboxUserProfile.fullName
                    isEditing = true
                },
                onDone: {
                    Task {
                        await post()
                    }
                },
                onCancel: {
                    miseboxUserProfile.fullName = lastValidName
                    isEditing = false
                }
            )
            
            if !isValid && isEditing {
                Text("First and last names cannot be empty.")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
        }
        .onAppear {
            lastValidName = miseboxUserProfile.fullName
            checkValidity()
        }
    }

    private func checkValidity() {
        isValid = !miseboxUserProfile.fullName.first.isEmpty && !miseboxUserProfile.fullName.last.isEmpty
    }

    private func post() async {
        checkValidity()
        if isValid {
            await miseboxUserManager.update(contexts: [.fullName])
        } else {
            print("Full name is invalid, cannot post.")
            miseboxUserProfile.fullName = lastValidName
        }
    }
}
