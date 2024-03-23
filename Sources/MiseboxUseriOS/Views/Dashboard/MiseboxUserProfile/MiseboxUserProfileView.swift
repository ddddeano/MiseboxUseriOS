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
    @StateObject var miseboxUserProfileNavigation = MiseboxUserProfileViewNavigation()

    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    public var body: some View {
        VStack {
            Text("MiseboxUserProfile")
            Text("Account Created: \(miseboxUserProfile.formattedAccountCreated)")
            ProfileListView(sections: MiseboxUserProfileViewNavigation.Routes.allCases) { section in
                miseboxUserProfileNavigation.router(section)
            }
        }
        .padding()
    }
}

public struct ProfileListView<Section: Identifiable, Destination: View>: View where Section: ProfileSection {
    let sections: [Section]
    let destinationView: (Section) -> Destination
    @EnvironmentObject var router: NavigationPathObject
    
    public init(sections: [Section], destinationView: @escaping (Section) -> Destination) {
        self.sections = sections
        self.destinationView = destinationView
    }
    
    public var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(sections) { section in
                    Button(action: {
                        router.route = NavigationPath([section])
                    }) {
                        HStack {
                            iconView(systemName: section.iconName)
                            Text(section.displayName)
                                .foregroundColor(Env.env.appLight)
                                .padding(.leading, 8)
                            Spacer()
                            Image(systemName: "chevron.right")
                                .foregroundColor(Env.env.appLight)
                        }
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Env.env.appDark.opacity(0.1)))
                    }
                    .buttonStyle(PlainButtonStyle())
                }
            }
            .padding()
        }
        .navigationDestination(for: Section.self) { section in
            destinationView(section)
        }
    }
    
    @ViewBuilder
    private func iconView(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
            .foregroundColor(Env.env.appLight)
    }
}

