//
//  HandleProfileView.swift
//
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

public struct HandleProfileView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @State private var isValid: Bool = true
    @State private var isEditing: Bool = false
    @State private var lastValidHandle: String = ""
    public init() {
    }
    public var body: some View {
        VStack {
            HStack {
                if !isEditing {
                    Text("@\(miseboxUser.handle)")
                        .displayValid(backgroundColor: .purple.opacity(0.1), borderColor: .purple)
                } else {
                    TextField("Enter Handle", text: $miseboxUser.handle, onEditingChanged: { isEditing in
                        self.isEditing = isEditing
                        if !isEditing {
                            lastValidHandle = miseboxUser.handle
                        }
                    }, onCommit: {
                        Task {
                            await post()
                        }
                    })
                    .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                }
                Spacer()
                EditToggleImageButton(
                    isEditing: $isEditing,
                    isValid: isValid,
                    onEdit: {
                        lastValidHandle = miseboxUser.handle
                        isEditing = true
                    },
                    onDone: {
                        Task {
                            await post()
                        }
                    },
                    onCancel: {
                        miseboxUser.handle = lastValidHandle
                        isEditing = false
                    }
                )
            }
            if !isValid && isEditing {
                Text("Handle cannot be empty.")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
        }
    }

    private func checkValidity() {
        isValid = !miseboxUser.handle.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }
    
    private func post() async {
        checkValidity()
        if isValid {
            await miseboxUserManager.update(contexts: [.handle])
        } else {
            print("Handle is invalid, reverting to last valid handle.")
            miseboxUser.handle = lastValidHandle
        }
    }
}
