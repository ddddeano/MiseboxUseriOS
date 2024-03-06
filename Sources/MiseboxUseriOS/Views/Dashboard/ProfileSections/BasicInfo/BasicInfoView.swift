//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

public struct BasicInfoView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    public init() {
    }
    
    public var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Divider()
                .padding(.top, 100)
            SectionTitle(title: "Basic Information")
            Divider()
            HandleProfileView()
           // FullNameProfileView()
            EmailProfileView()
            Divider()
            Spacer()
        }
        .padding()
        .sheetStyle(backgroundColor: .purple.opacity(0.1))
    }
}
