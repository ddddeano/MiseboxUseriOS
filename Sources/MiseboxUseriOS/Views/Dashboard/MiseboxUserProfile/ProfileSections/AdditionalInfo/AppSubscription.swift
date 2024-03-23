//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.03.2024.
//

import SwiftUI
import MiseboxiOSGlobal

struct AppSubscriptionView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    var body: some View {
        VStack {
            Text("Subscription Type:")
            Text("Subscription Status: Active : Inactive")
        }
        .padding()
    }
}



