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
    let vm: DashboardVM
    @Binding var fullName: MiseboxUserManager.FullName
    @State private var isValid: Bool = true
    @State private var isEditing: Bool = false
    @State private var lastValidFullName = MiseboxUserManager.FullName()
    var body: some View {
        VStack {
            HStack {
                if !isEditing {
                    Text(fullName.formattedCard)
                        .displayValid(backgroundColor: .purple.opacity(0.1), borderColor: .purple)
                } else {
                    VStack {
                        TextField("First Name", text: $fullName.first)
                            .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                            .onChange(of: fullName.first) { newValue in checkValidity() }
                        
                        TextField("Last Name", text: $fullName.last)
                            .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                            .onChange(of: fullName.last) { newValue in checkValidity() }
                        
                        TextField("Middle Name (Optional)", text: $fullName.middle)
                            .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                    }
                }
                Spacer()
                EditToggleImageButton(
                    isEditing: $isEditing,
                    isValid: isValid,
                    onEdit: {
                        isEditing = true
                    },
                    onDone: {
                        Task {
                            await post()
                        }
                    },
                    onCancel: {
                        fullName = lastValidFullName
                        isEditing = false
                    }
                )
            }
            
            if !isValid && isEditing {
                Text("First and Last names cannot be empty.")
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
        isValid = !fullName.first.isEmpty && !fullName.last.isEmpty
        if isValid {
            lastValidFullName = fullName
        }
    }
    
    private func post() async {
        checkValidity()
        if isValid {
            await vm.update([.fullName])
        } else {
            print("FullName is invalid, cannot post.")
            fullName = lastValidFullName
        }
    }
}

#Preview {
    FullNameProfileView(vm: DashboardVM(miseboxUserManager: MiseboxUserManager(role: .miseboxUser), signOutAction: {}), fullName: .constant(MiseboxUserManager.FullName(first: "Daniel", middle: "Marc", last: "Watson")))
}
