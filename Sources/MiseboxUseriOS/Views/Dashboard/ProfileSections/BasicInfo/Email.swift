//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import SwiftUI
import MiseboxiOSGlobal

/*struct EmailProfileView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @State private var isValid: Bool = true
    @State private var isEditing: Bool = false
    @State private var lastValidEmail: String = ""
    
    var body: some View {
        VStack {
            HStack {
                if !isEditing {
                    Text(miseboxUser.email)
                        .displayValid(backgroundColor: .purple.opacity(0.1), borderColor: .purple)
                } else {
                    TextField("Enter Email", text: $miseboxUser.email)
                        .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                        .keyboardType(.emailAddress)
                        .onChange(of: miseboxUser.email) { newValue in
                            checkValidity()
                        }
                }
                Spacer()
                EditToggleImageButton(
                    isEditing: $isEditing,
                    isValid: isValid,
                    onEdit: {},
                    onDone: {
                        await post()
                    },
                    onCancel: {
                        miseboxUser.email = lastValidEmail
                    }
                )
            }
            
            if !isValid && isEditing {
                Text("Email cannot be empty and must be valid.")
                    .foregroundColor(.red)
                    .padding(.top, 5)
            }
        }
        .onAppear {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                checkValidity()
            }
        }
    }
    
    private func checkValidity() {
        isValid = !miseboxUser.email.isEmpty && miseboxUser.email.contains("@") && miseboxUser.email.contains(".")
        
        if isValid {
            lastValidEmail = miseboxUser.email
        }
    }
    
    private func post() async {
        checkValidity()
        if isValid {
            await miseboxUserManager.update(contexts: [.email]) // Use miseboxUserManager to update email
        } else {
            print("Email is invalid, cannot post.")
            miseboxUser.email = lastValidEmail
        }
    }
}
*/
