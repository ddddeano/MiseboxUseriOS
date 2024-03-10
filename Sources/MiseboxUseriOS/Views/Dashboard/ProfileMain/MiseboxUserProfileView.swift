//
//  MiseboxUserProfile.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal
import _PhotosUI_SwiftUI


public protocol ProfileViewProtocol: View {
    var navigationPath: NavigationPath { get }
}

public struct MiseboxUserProfile: ProfileViewProtocol, View {
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    @Binding public var navigationPath: NavigationPath
    
    public init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
    }
    
    public var body: some View {
        List {
            DisclosureGroup("Personal Information") {
                HandleProfileView()
                FullNameProfileView()
            }
            .background(Color.white) // Change the color as needed

            DisclosureGroup("Contact Information") {
                EmailProfileView()
                AddressProfileView()  // Add your address view here
            }
            .background(Color.white) // Change the color as needed

            DisclosureGroup("Additional Information") {
                Text("Account Created: \(miseboxUserProfile.formattedAccountCreated)")
                Text("MiseCODE: \(miseboxUserProfile.miseCODE)")
                SubscriptionView()
                UserRolesView()
            }
            .background(Color.white) // Change the color as needed
        }
        .listStyle(GroupedListStyle())
        .background(Color.white) // Change the background color of the List
    }
}

struct MiseboxUserProfile_Previews: PreviewProvider {
    static var previews: some View {
     
        let navigationPath = Binding.constant(NavigationPath())

        MiseboxUserProfile(navigationPath: navigationPath)
            .environmentObject(MiseboxUserManager(role: .agent))
            .environmentObject(MiseboxUserManager.MiseboxUser.sandboxUser)
            .environmentObject(MiseboxUserManager.MiseboxUserProfile.sandboxUserProfile)
    }
}

struct AddressProfileView: View {
    var body: some View {
        Text("Address placeholder")
        // Replace this with your actual address view
    }
}
// Placeholder views for the not yet implemented views
struct ImageProfileView: View {
    var body: some View {
        Text("Image URL placeholder")
    }
}

struct VerifiedStatusView: View {
    var body: some View {
        Text("Verified status placeholder")
    }
}

struct SubscriptionView: View {
    var body: some View {
        Text("Subscription info placeholder")
    }
}

struct UserRolesView: View {
    var body: some View {
        Text("User roles info placeholder")
    }
}



public struct ProfileListView<Section: ProfileSection, Destination: View>: View {
    let sections: [Section]
    let destinationView: (Section) -> Destination
    @Binding var navigationPath: NavigationPath  // Now using a binding passed from the parent

    public init(sections: [Section], navigationPath: Binding<NavigationPath>, destinationView: @escaping (Section) -> Destination) {
        self.sections = sections
        self._navigationPath = navigationPath  // Initialize the binding
        self.destinationView = destinationView
    }

    public var body: some View {
        ScrollView {
            ForEach(sections, id: \.self) { section in
                Button {
                    print("Navigating to section: \(section)")
                    navigationPath.append(section)
                } label: {
                    HStack {
                        iconView(systemName: section.iconName)
                        Text(section.displayName)
                        Spacer()
                        iconView(systemName: "chevron.right")
                    }
                    .foregroundColor(Env.env.appLight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())
            }
            .sectionStyle(borderColor: Env.env.appLight)
        }
        .padding()
        .pageStyle(backgroundColor: Env.env.appDark.opacity(0.1))
    }

    @ViewBuilder
    private func iconView(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
    }
}
