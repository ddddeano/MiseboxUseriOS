//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 10.03.2024.
//

import SwiftUI

struct ContactInfoView: View {
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    var body: some View {
        VStack {
            EmailProfileView()
            // Assuming AddressProfileView is implemented to edit the address
           // AddressProfileView()
            Spacer()
        }
        .padding()
        .navigationTitle("Contact Information")
    }
}
