//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 10.03.2024.
//

import SwiftUI
import MiseboxiOSGlobal

struct AdditionalInfoView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    var body: some View {
        VStack {
            SectionTitle(title: "Additional Information")
            Divider()
            ScrollView {
                Text("Account Created: \(miseboxUserProfile.accountCreated, formatter: DateFormatter())")
                Text("Mise CODE: \(miseboxUserProfile.miseCODE)")
                AppSubscriptionView()
                UserRolesView()
                AccountProvidersView()
            }
            Divider()
            Spacer()
        }
        .padding()
        .sheetStyle(backgroundColor: Env.env.appDark.opacity(0.1))
    }
}


