//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import Foundation
import SwiftUI
struct MediumInfoView: View {
    var vm: DashboardVM
    
    var body: some View {
        VStack {
            Text("Medium Information")
                .font(.title)
            Text("Subscription Type: \(vm.miseboxUserManager.miseboxUserProfile.subscription.type.rawValue)")
            Text("Account Providers: \(vm.miseboxUserManager.miseboxUserProfile.accountProviders.joined(separator: ", "))")
        }
        .padding()
    }
}
