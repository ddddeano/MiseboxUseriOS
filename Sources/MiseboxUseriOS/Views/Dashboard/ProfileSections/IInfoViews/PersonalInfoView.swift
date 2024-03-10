//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 10.03.2024.
//

import SwiftUI

struct PersonalInfoView: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser

    var body: some View {
        VStack {
            HandleProfileView()
            FullNameProfileView()
            Spacer()
        }
        .padding()
        .navigationTitle("Personal Information")
    }
}
