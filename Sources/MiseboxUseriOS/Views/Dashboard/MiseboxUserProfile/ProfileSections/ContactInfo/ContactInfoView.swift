//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.03.2024.
//

import SwiftUI
import MiseboxiOSGlobal

struct ContactInfoView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    var body: some View {
        VStack {
            SectionTitle(title: "Contact Information")
            Divider()
            ScrollView {
                EmailProfileView()
            }
            Divider()
            Spacer()
        }
        .padding()
        .sheetStyle(backgroundColor: Env.env.appDark.opacity(0.1))
    }
}
