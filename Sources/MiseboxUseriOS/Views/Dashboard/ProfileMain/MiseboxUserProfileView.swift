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

}

public struct MiseboxUserProfile: ProfileViewProtocol, View {
    @EnvironmentObject var navPath: NavigationPathObject

    
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    @StateObject var nav = UserProfileViewNavigation()

    public init() {
        self._nav = StateObject(wrappedValue: UserProfileViewNavigation())
    }

    public var body: some View {
        VStack {
            Text("Account Created: \(miseboxUserProfile.formattedAccountCreated)")
            ProfileListView(sections: UserProfileViewNavigation.ProfileSections.allCases, navigationPath: $navPath.navigationPath) { section in
                section.view()
            }
        }
        .navigationDestination(for: UserProfileViewNavigation.ProfileSections.self) { profileSection in
            switch profileSection {
            case .personalInfo:
                UserInfoView()
            case .contactInfo:
                ContactInfoView()
            case .additionalInfo:
                AdditionalInfoView()
            }
        }
    }
}
public struct ProfileListView<Section: ProfileSection & Identifiable, Destination: View>: View {
    let sections: [Section]
    let destinationView: (Section) -> Destination
    @Binding var navigationPath: NavigationPath

    public init(sections: [Section], navigationPath: Binding<NavigationPath>, destinationView: @escaping (Section) -> Destination) {
        self.sections = sections
        self._navigationPath = navigationPath
        self.destinationView = destinationView
    }

    public var body: some View {
        ScrollView {
            ForEach(sections, id: \.self) { section in
                Button {
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
    }
}
