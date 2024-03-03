//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import SwiftUI
import MiseboxiOSGlobal

struct EmailProfileView: View {
    let vm: DashboardVM
    @Binding var email: String
    @State private var isValid: Bool = true
    @State private var isEditing: Bool = false
    @State private var lastValidEmail: String = ""
    
    var body: some View {
        VStack {
            HStack {
                if !isEditing {
                    Text(email)
                        .displayValid(backgroundColor: .purple.opacity(0.1), borderColor: .purple)
                } else {
                    TextField("Enter Email", text: $email)
                        .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                        .keyboardType(.emailAddress)
                        .onChange(of: email) { newValue in
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
                        email = lastValidEmail
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
        isValid = !email.isEmpty && email.contains("@") && email.contains(".")
        
        if isValid {
            lastValidEmail = email
        }
    }
    
    private func post() async {
        checkValidity()
        if isValid {
            await vm.update([.email])
        } else {
            print("Email is invalid, cannot post.")
            email = lastValidEmail
        }
    }
}


#Preview {
    EmailProfileView(vm: DashboardVM(miseboxUserManager: MiseboxUserManager(role: .miseboxUser), signOutAction: {}), email: .constant("test@test.com"))
}
