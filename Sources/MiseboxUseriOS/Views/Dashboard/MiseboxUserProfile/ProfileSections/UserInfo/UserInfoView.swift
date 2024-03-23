//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal
struct UserInfoView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    
    var body: some View {
        VStack {
            SectionTitle(title: "User Information")
            Divider()
            ScrollView {
                HandleProfileView()
                FullNameProfileView()
               // VerifiedView()
            }
            Divider()
            Spacer()
        }
        .padding()
        .sheetStyle(backgroundColor: Env.env.appDark.opacity(0.1))
    }
}

