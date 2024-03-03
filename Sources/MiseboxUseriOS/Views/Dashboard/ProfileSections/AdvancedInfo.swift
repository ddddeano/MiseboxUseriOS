//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI

struct AdvancedInfoView: View {
    var vm: DashboardVM
    
    var body: some View {
        VStack {
            Text("Advanced Information")
                .font(.title)
            Text("MiseCODE: \(vm.miseboxUserManager.miseboxUser.miseCODE)")
            Text("Verified: \(vm.miseboxUserManager.miseboxUser.verified ? "Yes" : "No")")
            // Add more advanced info fields here
        }
        .padding()
    }
}
