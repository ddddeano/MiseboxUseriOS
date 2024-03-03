//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

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

struct AccountProvidersSectionView: View {
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    @State private var showEmailSignIn = false
    
    var body: some View {
        VStack {
            if miseboxUserProfile.accountProviders.isEmpty {
                Text("Your account is currently anonymous. To get the full benefits, please link an account.")
                
                CircleButton(iconType: .system("envelope.fill"), size: 50, background: .purple.opacity(0.2), foregroundColor: .purple, strokeColor: .purple, action: {
                  //  showEmailSignIn.toggle()
                })
                
                .padding()
                
                CircleButton(iconType: .asset("google-icon"), size: 50, background: .purple.opacity(0.2), foregroundColor: .purple, strokeColor: .purple, action: {                     Task {
                       // try await vm.verifyMiseboxUser(with: .google)
                    }
                })
                .padding()
                
                CircleButton(iconType: .asset("apple-logo"), size: 50, background: .purple.opacity(0.2), foregroundColor: .purple, strokeColor: .purple, action: {
                
                    Task {
                       // try await vm.verifyMiseboxUser(with: .apple)
                    }
                })
                .padding()
            } else {
                Text("Linked with: \(miseboxUserProfile.accountProviders.joined(separator: ", "))")
            }
        }
    }
}
