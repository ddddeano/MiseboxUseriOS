//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.03.2024.
//

import SwiftUI
import MiseboxiOSGlobal
import FirebaseiOSMisebox

struct AccountProvidersView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    var body: some View {
        VStack {
            ForEach(miseboxUserProfile.accountProviders, id: \.self) { provider in
                Text("Provider: \(provider.rawValue)")
            }
        }
        .padding()
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
              //  Text("Linked with: \(miseboxUserProfile.accountProviders.joined(separator: ", "))")
            }
        }
    }
}
