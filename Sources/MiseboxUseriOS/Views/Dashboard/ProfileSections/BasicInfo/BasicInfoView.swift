//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

struct BasicInfoView: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    var vm: ProfileDashboardVM
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
                .padding(.top, 100)
            SectionTitle(title: "Basic Information")
            Divider()
            HandleProfileView(vm: vm, handle: $miseboxUser.handle)
            FullNameProfileView(vm: vm, fullName: $miseboxUserProfile.fullName)
            EmailProfileView(vm: vm, email: $miseboxUser.email)
            Divider()
            Spacer()
        }
        .padding()
        .sheetStyle(backgroundColor: .purple.opacity(0.1))
    }
}
