//
//  File.swift
//  
//
//  Created by Daniel Watson on 09.03.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

struct ProfileTextField: View {
    var title: String
    var text: Binding<String>
    var isEditing: Bool
    
    var body: some View {
        Group {
            if isEditing {
                TextField(title, text: text)
                    .displayEdit(backgroundColor: .purple.opacity(0.2), borderColor: Env.env.appLight)
            } else {
                ZStack(alignment: .topLeading) {
                    Text(text.wrappedValue)
                        .frame(minWidth: 200, alignment: .leading)
                        .displayValid(backgroundColor: .purple.opacity(0.1), borderColor: Env.env.appLight)
                    Text(title)
                        .font(.caption)
                        .font(.system(size: 5))
                        .padding(2)
                        .foregroundColor(Env.env.appLight)
                        .background(
                            RoundedRectangle(cornerRadius: 4)
                                .stroke(Env.env.appLight, lineWidth: 1)
                                .background(Env.env.appDark)
                        )
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                        .offset(x: -10, y: -15)
                }
            }
        }
        .padding()
    }
}

struct FieldInput {
    var title: String
    var text: Binding<String>
}


struct ProfileInput: View {
    var inputs: [FieldInput]
    
    @Binding var isEditing: Bool
    @State private var validationResult: (isValid: Bool, message: String) = (true, "")

    var onEdit: () -> Void
    var onDone: () -> Void
    var onCancel: () -> Void
    var onCheck: () -> (isValid: Bool, message: String)
    
    var body: some View {
        VStack {
            HStack(alignment: .center) {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(inputs.indices, id: \.self) { index in
                        ProfileTextField(title: inputs[index].title, text: inputs[index].text, isEditing: isEditing)
                            .onChange(of: inputs[index].text.wrappedValue) { _ in
                                if isEditing {
                                    validationResult = onCheck()
                                }
                            }
                    }
                }
                Spacer()
                EditToggleImageButton(
                    isEditing: $isEditing,
                    isValid: validationResult.isValid,
                    onEdit: onEdit,
                    onDone: {
                        validationResult = onCheck()
                        onDone()
                    },
                    onCancel: onCancel
                )
                .padding(.trailing)
            }
            
            if isEditing && !validationResult.isValid {
                Text(validationResult.message)
                    .foregroundColor(Env.env.appLight)
                    .padding(.top, 5)
            }
        }
    }
}

struct UpdateableBool: View {
    var title: String
    @Binding var value: Bool
    let updateAction: () async -> Void

    var body: some View {
        Toggle(isOn: $value) {
            Text(title)
        }
        .onChange(of: value) { newValue in
            Task {
                await updateAction()
            }
        }
    }
}
struct UpdateableArrayOfStrings: View {
    var title: String
    @Binding var array: [String]
    let updateAction: () async -> Void

    var body: some View {
        VStack {
            Text(title)
            ForEach(array, id: \.self) { item in
                Text(item)
            }
            Button("Update") {
                Task {
                    await updateAction()
                }
            }
        }
    }
}


struct UpdateableSubscription: View {
    var title: String
    @Binding var subscription: MiseboxUserManager.Subscription
    let updateAction: () async -> Void

    var body: some View {
        VStack {
            Text("Subscription Type: \(subscription.type.rawValue)")
            Button("Change Subscription") {
                Task {
                    await updateAction()
                }
            }
        }
    }
}

