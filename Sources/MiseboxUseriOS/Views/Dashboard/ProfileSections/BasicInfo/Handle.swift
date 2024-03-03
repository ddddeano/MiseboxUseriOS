//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

struct HandleProfileView: View {
    let vm: ProfileDashboardVM
    @Binding var handle: String
    @State private var isValid: Bool = true
    @State private var isEditing: Bool = false
    @State private var lastValidHandle: String = ""

    var body: some View {
        VStack {
            HStack {
                if !isEditing {
                    Text("@\(handle)")
                    .displayValid(backgroundColor: .purple.opacity(0.1), borderColor: .purple)
                } else {
                    TextField("Enter Handle", text: $handle)
                        .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: .purple)
                        .onChange(of: handle) { newValue in
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
                        handle = lastValidHandle
                    })
            }
            
            if !isValid && isEditing{
                Text("Handle cannot be empty.")
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
        isValid = !handle.isEmpty
        
        if isValid {
            lastValidHandle = handle
        }
    }
    
    private func post() async {
        checkValidity()
        if isValid {
            await vm.update([.handle])
        } else {
            print("Handle is invalid, cannot post.")
            handle = lastValidHandle
        }
    }
}

#Preview {
    HandleProfileView(vm: ProfileDashboardVM(miseboxUserManager: MiseboxUserManager(role: .miseboxUser), signOutAction: {}), handle: .constant("username"))
}

