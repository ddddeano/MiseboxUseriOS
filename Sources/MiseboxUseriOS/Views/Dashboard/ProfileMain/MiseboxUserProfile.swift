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
    @Binding public var navigationPath: NavigationPath
    @StateObject var nav = UserProfileViewNavigation()
    
    let sections: [UserProfileViewNavigation.ProfileSections] = [.basicInfo]
    
    public init(navigationPath: Binding<NavigationPath>) {
        self._navigationPath = navigationPath
        self._nav = StateObject(wrappedValue: UserProfileViewNavigation())
    }
    
    public var body: some View {
        ProfileListView(sections: sections, navigationPath: $navigationPath) { section in
            section.view()
        }
        .navigationDestination(for: UserProfileViewNavigation.ProfileSections.self) { profileSection in
            switch profileSection {
            case .basicInfo:
                BasicInfoView()
            }
        }
    }
}

public struct ProfileListView<Section: ProfileSection, Destination: View>: View {
    @EnvironmentObject var env: EnvironmentManager
    
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
                    .foregroundColor(env.appLight)
                    .frame(maxWidth: .infinity, alignment: .leading)
                }
                .buttonStyle(PlainButtonStyle())
                .contentShape(Rectangle())
            }
            .sectionStyle(borderColor: env.appLight)
        }
        .padding()
        .pageStyle(backgroundColor: env.appDark.opacity(0.1))
    }

    @ViewBuilder
    private func iconView(systemName: String) -> some View {
        Image(systemName: systemName)
            .resizable()
            .scaledToFit()
            .frame(width: 24, height: 24)
    }
}
