//
//  MiseboxUserProfile.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//


import SwiftUI
import MiseboxiOSGlobal

public class SMiseboxUserProfileViewNavigation: ObservableObject {
    public init() {}

    public enum Routes: String, CaseIterable, Identifiable, ProfileSection {
        case userInfo = "User Information"
        case contactInfo = "Contact Information"
        case additionalInfo = "Additional Information"

        public var id: Self { self }

        public var iconName: String {
            switch self {
            case .userInfo: return "person.fill"
            case .contactInfo: return "envelope.fill"
            case .additionalInfo: return "gear"
            }
        }

        public var displayName: String { self.rawValue }
    }
}

public struct MiseboxUserProfile: View {
    @EnvironmentObject var router: NavigationPathObject

    public var body: some View {
        VStack {
            Text("MiseboxUserProfile")

            Button("Test Navigation") {
                print("Current route before setting: \(router.route)")
                router.route = NavigationPath([SMiseboxUserProfileViewNavigation.Routes.userInfo])
                print("Route set successfully")
                print("Current route after setting: \(router.route)")
            }
            .padding()
        }
        .navigationDestination(for: SMiseboxUserProfileViewNavigation.Routes.self) { route in
            switch route {
            case .userInfo:
                UserInfoView()
            case .contactInfo:
                ContactInfoView()
            case .additionalInfo:
                AdditionalInfoView()
            }
        }
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

