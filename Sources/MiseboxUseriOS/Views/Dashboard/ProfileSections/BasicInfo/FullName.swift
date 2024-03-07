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
        VStack(alignment: .leading, spacing: 10) {
            if !isEditing {
                HStack {
                    Text(miseboxUserProfile.fullName.formatted)
                        .displayValid(backgroundColor: .purple.opacity(0.1), borderColor: .purple)
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
                }
            } else {
                VStack {
                    HStack {
                        TextField("First Name", text: $miseboxUserProfile.fullName.first)
                            .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                        Spacer()
                    }
                    HStack {
                        TextField("Middle Name", text: $miseboxUserProfile.fullName.middle)
                            .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                        Spacer()
                    }
                    HStack {
                        TextField("Last Name", text: $miseboxUserProfile.fullName.last)
                            .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
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
                    }
                }
                .onChange(of: miseboxUserProfile.fullName) { _ in
                    checkValidity()
                }
            }

            if !isValid && isEditing {
                Text("First and last names cannot be empty.")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
        }
        .padding() // Add padding around the entire VStack
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
