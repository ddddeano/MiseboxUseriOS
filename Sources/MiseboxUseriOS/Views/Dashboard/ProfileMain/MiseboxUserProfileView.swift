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
    @State private var isPersonalInfoExpanded: Bool = true
    @State private var isContactInfoExpanded: Bool = false
    @State private var isAdditionalInfoExpanded: Bool = false
    
    public init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
    }
    
    public var body: some View {
        List {
            DisclosureGroup("Personal Information", isExpanded: $isPersonalInfoExpanded) {
                HandleProfileView()
                FullNameProfileView()
                ImageProfileView()  // Placeholder for the image URL view
                VerifiedStatusView()  // Placeholder for the verified status view
            }

            DisclosureGroup("Contact Information", isExpanded: $isContactInfoExpanded) {
                EmailProfileView()
                // Add more contact information fields as they become available
            }

            DisclosureGroup("Additional Information", isExpanded: $isAdditionalInfoExpanded) {
                Text("Account Created: \(miseboxUserProfile.formattedAccountCreated)")
                Text("MiseCODE: \(miseboxUserProfile.miseCODE)")
                SubscriptionView()  // Placeholder for subscription info
                UserRolesView()  // Placeholder for user roles info
                // Add more additional information fields as they become available
            }
        }
        .listStyle(GroupedListStyle())
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
