//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 10.03.2024.
//

import SwiftUI
import MiseboxiOSGlobal

struct UserInfoView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            SectionTitle(title: "User Information")
            Divider()
            ScrollView {
                HandleProfileView()
                FullNameProfileView()
            }
            Divider()
            Spacer()
        }
        .environmentObject(miseboxUserManager)
        .environmentObject(miseboxUser)
        .environmentObject(miseboxUserProfile)
        .padding()
        .sheetStyle(backgroundColor: .purple.opacity(0.1))
    }
}

