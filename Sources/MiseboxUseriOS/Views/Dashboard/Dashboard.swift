
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

class DashboardNavigation: ObservableObject {
    var options: [DashboardSelectionOptions] = [.miseboxUser, .role]
    
    enum DashboardSelectionOptions: String, CaseIterable, Identifiable {
        case miseboxUser, role
        
        var id: Self { self }
        
        var displayName: String { rawValue.capitalized }
    }
}
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
            NavigationView {
                userCardView
                    .onTapGesture {
                        navigationPath.append(DashboardNavigation.DashboardSelectionOptions.miseboxUser)
                    }
                
                if !(cvm.roleManager is NoRoleManager) {
                    OptionalView(roleCardView)
                        .onTapGesture {
                            navigationPath.append(DashboardNavigation.DashboardSelectionOptions.role)
                        }
                }
                SignOutButton(cvm: cvm)
            }
            .navigationDestination(for: DashboardNavigation.DashboardSelectionOptions.self) { option in
                switch option {
                case .miseboxUser:
                    userProfileView
                case .role:
                    OptionalView(roleProfileView)
                }
            }
        }
    }

    struct SignOutButton: View {
        @ObservedObject var cvm: ContentViewModel<RoleManagerType>
        
        var body: some View {
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
    }
}

struct OptionalView<Content: View>: View {
    var content: Content?
    
    init(_ content: Content?) {
        self.content = content
    }
    
    var body: some View {
        Group {
            if let content = content {
                content
            } else {
                EmptyView()
            }
        }
    }
}


