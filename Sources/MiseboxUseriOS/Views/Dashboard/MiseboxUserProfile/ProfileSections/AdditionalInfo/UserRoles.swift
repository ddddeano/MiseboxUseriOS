//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.03.2024.
//

import SwiftUI

struct UserRolesView: View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    var body: some View {
        VStack {
            ForEach(miseboxUserProfile.userRoles, id: \.role.doc) { role in
                Text("Role: \(role.role.doc)")
            }
        }
        .padding()
    }
}


#Preview {
    UserRolesView()
}
//
//  File.swift
//
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
//
//  UserRoles.swift
//  MiseboxUseriOS
//
//  Created by Daniel Watson on 17.02.2024.
//

import SwiftUI
import MiseboxiOSGlobal

// Specific Types MiseboxUserProfile
struct UpdateableUserRoles: View {
    let vm: DashboardVM
    var title: String
    @Binding var userRoles: [MiseboxUserManager.UserRole]
    let updateAction: () async -> Void

    var body: some View {
        VStack(alignment: .leading) {
            SectionTitle(title: title)
            
            yourRolesSection
            
           // availableRolesSection
            
        }
    }
    
    private var yourRolesSection: some View {
        VStack(alignment: .leading) {
            SectionTitle(title: "Your Roles")
            
            ForEach(Array(userRoles.enumerated()), id: \.element.role.doc) { index, userRole in
                    Text(userRole.role.doc.capitalized)
                        .padding(.vertical, 2)
                        .font(.subheadline) // Consistent font styling
                .padding(.vertical, 2)
            }
        }
    }
    
   /* private var availableRolesSection: some View {
        VStack(alignment: .leading) {
            SectionTitle(title: "Available Roles")
            ForEach(MiseboxUserManager.Role.allCases.filter { role in
                !userRoles.contains(where: { $0.role.doc == role.doc })
            }, id: \.doc) { role in
                Text("avaiulablRole")
                //AvailableRole(role: role, userRoles: $userRoles, updateAction: updateAction, motto: vm.motto(for: role))
            }
        }
    }*/
}

/*
struct AvailableRole: View {
    let role: MiseboxUserManager.Role
    @Binding var userRoles: [MiseboxUserManager.UserRole]
    let updateAction: () async -> Void
    @State private var handle = ""
    var motto: String
    
    var body: some View {
        VStack {
            HStack(alignment: .top) {
                CircleButton(iconType: .asset("LogoIcon"), size: 50, background: .purple.opacity(0.2), foregroundColor: .purple, strokeColor: .purple, action: {})
                VStack(alignment: .leading) {
                    
                    Text(role.doc.capitalized)
                        .font(.headline)
                        .foregroundColor(.primary)
                    Text(motto)
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
                .padding(.horizontal)
                Spacer()
            }
          
            TextField("@: Create Handle", text: $handle)
                .padding(.horizontal)
                .frame(width: 200, height: 36)
                .background(Color.secondary.opacity(0.5))
                .cornerRadius(8)
                .padding(.bottom, 16)


            
            Spacer()
            
            Button(action: addRole) {
                Text("Create App")
                    .foregroundColor(.white)
                    .padding()
                    .background(role.color)
                    .cornerRadius(8)
            }
            .disabled(handle.isEmpty)
        }
        .padding()
        .background(
            LinearGradient(gradient: Gradient(colors: [role.color.opacity(0.5), role.color.opacity(0.1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
        )
        .cornerRadius(10)
        .shadow(radius: 2)
    }
    
    private func addRole() {
        let newUserRole = MiseboxUserManager.UserRole(role: role, handle: handle)
        userRoles.append(newUserRole)
        handle = ""
        Task {
            await updateAction()
        }
    }
}*/
/*
#if DEBUG
final class PreviewHelpers {
    static func mockMiseboxUserManager() -> MiseboxUserManager {
        let manager = MiseboxUserManager(role: .chef)
        let mockEcosystemData = EcosystemData()
        mockEcosystemData.miseboxUserMotto = "Manage Kitchens like a Pro; Design Menus, Dishes, and Recipes. Effortlessly organise your Mise en Place, Training, and Records."
        mockEcosystemData.agentMotto = "Filter Through Jobs, Highlight Your Profile, and Secure Gigs. Access a Wealth of Flexible Opportunities and Just-in-Time Assignments."
        mockEcosystemData.recruiterMotto = "Manage Your Human Resources, Recruit on the Fly; Post jobs, create Teams and Link Your Kitchens with Misebox Agents"
        mockEcosystemData.chefMotto = "Manage Kitchens like a Pro; Design Menus, Dishes, and Recipes. Effortlessly organise your Mise en Place, Training, and Records."
        manager.ecosystemData = mockEcosystemData
        return manager
    }
}
#endif

struct UpdateableUserRoles_Previews: PreviewProvider {
    static var previews: some View {
        let mockManager = PreviewHelpers.mockMiseboxUserManager()
        let mockViewModel = DashboardVM(miseboxUserManager: mockManager, signOutAction: {})
        let mockUserRoles = [MiseboxUserManager.exampleUserRole]

        UpdateableUserRoles(vm: mock  ViewModel, title: "Preview Roles", userRoles: .constant(mockUserRoles)) {
            print("Update action triggered")
        }
    }
}
*/
