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

public struct MiseboxUserProfile: View {
    @EnvironmentObject var router: NavigationPathObject
    @StateObject var navigation = MiseboxUserProfileViewNavigation()
    
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    public var body: some View {
        VStack {
            Text("MiseboxUserProfile")
            Text("Account Created: \(miseboxUserProfile.formattedAccountCreated)")
            ProfileListView(sections: MiseboxUserProfileViewNavigation.Routes.allCases) { section in
                print("Selected section: \(section.displayName)")
                router.route.append(section)
            }
        }
        .navigationDestination(for: MiseboxUserProfileViewNavigation.Routes.self) { route in
            navigation.router(route)
        }
        .padding()
    }
}

public struct ProfileListView<Section: ProfileSection>: View {
    let sections: [Section]
    let onSectionSelected: (Section) -> Void

    // Public initializer
    public init(sections: [Section], onSectionSelected: @escaping (Section) -> Void) {
        self.sections = sections
        self.onSectionSelected = onSectionSelected
    }

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(sections, id: \.id) { section in
                    Button(action: {
                        self.onSectionSelected(section)
                    }) {
                        HStack {
                            Image(systemName: section.iconName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 24, height: 24)
                                .foregroundColor(Env.env.appDark)
                            Text(section.displayName)
                                .foregroundColor(Env.env.appDark)
                                .padding(.vertical, 10)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Env.env.appDark)
                        }
                        .padding(.horizontal)
                        .frame(maxWidth: .infinity)
                        .background(RoundedRectangle(cornerRadius: 10).fill(Env.env.appDark.opacity(0.1)))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
    }
}


