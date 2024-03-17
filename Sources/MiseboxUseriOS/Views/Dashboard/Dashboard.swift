
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

// DashboardNavigation with RoleProfileView as a generic parameter.
public class DashboardNavigation<RoleProfileView: View>: ObservableObject {
    public var options = [DashboardViewNavigationOptions.user, .role]
    
    public enum DashboardViewNavigationOptions: String, CaseIterable, Identifiable {
        case user, role

        public var id: Self { self }

        public var iconName: String {
            switch self {
            case .user: return "person"
            case .role: return "briefcase"
            }
        }
        public var displayName: String { rawValue.capitalized }
    }

    public var roleProfileView: RoleProfileView

    public init(roleProfileView: RoleProfileView) {
        self.roleProfileView = roleProfileView
    }

    @ViewBuilder
    public func dashboardViewPaths(item: DashboardViewNavigationOptions) -> some View {
        switch item {
        case .user:
            MiseboxUserProfile()
        case .role:
            roleProfileView
        }
    }
}

// UserCardView as a placeholder for user content.
public struct UserCardView: View {
    public var body: some View {
        VStack {
            Text("User Card").font(.title).padding()
            Image(systemName: "person.fill").resizable().frame(width: 100, height: 100).padding()
            Text("This is a placeholder for user-related content.").padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding()
    }
    
    public init() {}
}

public struct Dashboard<RoleManagerType: RoleManager, RoleProfileView: ProfileViewProtocol, RoleCardView: CardViewProtocol>: View {
    @EnvironmentObject var navPath: NavigationPathObject
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @ObservedObject var cvm: ContentViewModel<RoleManagerType>
    @StateObject var dashboardNav: DashboardNavigation<RoleProfileView>
    
    @Binding var isAuthenticated: Bool
    
    public var roleCardView: RoleCardView?

    public init(cvm: ContentViewModel<RoleManagerType>, dashboardNav: DashboardNavigation<RoleProfileView>, isAuthenticated: Binding<Bool>, roleCardView: RoleCardView?) {
        self._cvm = ObservedObject(wrappedValue: cvm)
        self._dashboardNav = StateObject(wrappedValue: dashboardNav)
        self._isAuthenticated = isAuthenticated
        self.roleCardView = roleCardView
    }
    
    public var body: some View {
        if cvm.isAnon {
            AnonymousUserCard(isAuthenticated: $isAuthenticated)
        } else {
            VStack {
                UserCardView().onTapGesture { navPath.navigationPath.append(dashboardNav.options[0]) }.padding(.bottom, 5)
                OptionalView(content: roleCardView).onTapGesture { navPath.navigationPath.append(dashboardNav.options[1]) }.padding(.bottom, 5)
                SignOutButton(cvm: cvm)
            }
            .navigationDestination(for: DashboardNavigation.DashboardViewNavigationOptions.self) { option in
                dashboardNav.dashboardViewPaths(item: option)
            }
        }
    }

    struct SignOutButton: View {
        @ObservedObject var cvm: ContentViewModel<RoleManagerType>
        
        public var body: some View {
            Button("Sign Out") { Task { await cvm.signOut() } }
            .foregroundColor(.red)
            .padding()
            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 2))
        }
        
        public init(cvm: ContentViewModel<RoleManagerType>) {
            self._cvm = ObservedObject(wrappedValue: cvm)
        }
    }
}

public struct OptionalView<Content: View>: View {
    var content: Content?

    public init(content: Content?) {
        self.content = content
    }

    public var body: some View {
        Group {
            if let content = content {
                content
            } else {
                EmptyView()
            }
        }
    }
}
