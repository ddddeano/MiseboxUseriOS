
//
//  [MiseboxUseriOS]Dashboard.swift
//  MiseboxUseriOS
//
//  Created by Daniel Watson on 26.02.2024.
//
import SwiftUI
import FirebaseiOSMisebox
import Firebase
import MiseboxiOSGlobal

public struct Dashboard<
    RoleManagerType: RoleManager,
    RoleProfileView: ProfileViewProtocol,
    RoleCardView: CardViewProtocol,
    UserProfileView: ProfileViewProtocol,
    UserCardView: CardViewProtocol
>: View {

    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @ObservedObject var cvm: ContentViewModel<RoleManagerType>

    @Binding var navigationPath: NavigationPath
    @Binding var isAuthenticated: Bool

    public var userProfileView: UserProfileView
    public var userCardView: UserCardView
    public var roleProfileView: RoleProfileView?
    public var roleCardView: RoleCardView?

    public init(cvm: ContentViewModel<RoleManagerType>, navigationPath: Binding<NavigationPath>, isAuthenticated: Binding<Bool>, userProfileView: UserProfileView, userCardView: UserCardView, roleProfileView: RoleProfileView? = nil, roleCardView: RoleCardView? = nil) {
        self._cvm = ObservedObject(wrappedValue: cvm)
        self._navigationPath = navigationPath
        self._isAuthenticated = isAuthenticated
        self.userProfileView = userProfileView
        self.userCardView = userCardView
        self.roleProfileView = roleProfileView
        self.roleCardView = roleCardView
    }

    public var body: some View {
        if cvm.isAnon {
            anonView
        } else {
            dashboardView
        }
    }

    private var anonView: some View {
        AnonymousUserCard(isAuthenticated: $isAuthenticated)
    }

    private var dashboardView: some View {
        VStack {
            NavigationStack(path: $navigationPath) {
                userCardView
                    .onTapGesture {
                        navigationPath.append(ProfileDestination.user)
                    }

                if let roleProfileView = roleProfileView, let roleCardView = roleCardView {
                    roleCardView
                        .onTapGesture {
                            navigationPath.append(ProfileDestination.role)
                        }
                }

                Button("Sign Out") {
                    Task {
                        await cvm.signOut()
                    }
                }
                .foregroundColor(.red)
                .padding()
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.red, lineWidth: 2)
                )
            }
            .navigationDestination(for: ProfileDestination.self) { destination in
                switch destination {
                case .user:
                    userProfileView
                case .role:
                    roleProfileView ?? AnyView(Text("Role profile not available"))
                }
            }
        }
    }

    enum ProfileDestination: Hashable {
        case user
        case role
    }
}


    




