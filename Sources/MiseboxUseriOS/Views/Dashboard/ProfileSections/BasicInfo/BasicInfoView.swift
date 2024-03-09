//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

struct BasicInfo: View {
    @StateObject var miseboxUserManager = MiseboxUserManager(role: .miseboxUser)
    @StateObject var miseboxUser = MiseboxUserManager.MiseboxUser.sandboxUser
    @StateObject var miseboxUserProfile = MiseboxUserManager.MiseboxUserProfile.sandboxUserProfile
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            SectionTitle(title: "User Information")
            Divider()
            ScrollView {
                HandleProfileView()
                FullNameProfileView()
                EmailProfileView()
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
