//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 10.03.2024.
//

import SwiftUI

struct AdditionalInfoView: View {
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    
    var body: some View {
        VStack {
            Text("Account Created: \(miseboxUserProfile.formattedAccountCreated)")
            Text("MiseCODE: \(miseboxUserProfile.miseCODE)")
            AppSubscriptionView()
            UserRolesView()
            Spacer()
        }
        .padding()
        .navigationTitle("Additional Information")
    }
}
struct AppSubscriptionView: View {
    var body: some View {
        VStack {
            Text("Subscription Details Placeholder")
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}

struct UserRolesView: View {
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    
    var body: some View {
        VStack {
            Text("User Roles Placeholder")
            ForEach(miseboxUserProfile.userRoles, id: \.role.doc) { role in
                Text(role.role.doc)
            }
        }
        .padding()
        .background(Color.gray.opacity(0.2))
        .cornerRadius(10)
    }
}
