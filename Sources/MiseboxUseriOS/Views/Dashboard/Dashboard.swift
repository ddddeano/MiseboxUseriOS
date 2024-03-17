
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

class DashboardNavigation<RoleProfileView: View>: ObservableObject {
    var options: [DashboardViewNavigationOptions] = [.user, .role]
    
    enum DashboardViewNavigationOptions: String, CaseIterable, Identifiable {
        case user, role
        
        var id: Self { self }
        
        var iconName: String {
            switch self {
            case .user: return "person"
            case .role: return "briefcase"
            }
        }
        var displayName: String { rawValue.capitalized }
    }
    
    var roleProfileView: RoleProfileView

    init(roleProfileView: RoleProfileView) {
        self.roleProfileView = roleProfileView
    }
    
    @ViewBuilder
    func dashboardViewPaths(item: DashboardViewNavigationOptions) -> some View {
        switch item {
        case .user:
            MiseboxUserProfile()
        case .role:
            roleProfileView
        }
    }
}
struct UserCardView: View {
    var body: some View {
        VStack {
            Text("User Card")
                .font(.title)
                .padding()
            Image(systemName: "person.fill")
                .resizable()
                .frame(width: 100, height: 100)
                .padding()
            Text("This is a placeholder for user-related content.")
                .padding()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.gray.opacity(0.1))
        .cornerRadius(12)
        .padding()
    }
}


struct Dashboard<
    RoleManagerType: RoleManager,
    RoleProfileView: ProfileViewProtocol,
    RoleCardView: CardViewProtocol
>: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @ObservedObject var cvm: ContentViewModel<RoleManagerType>
    @EnvironmentObject var navPath: NavigationPathObject
    @StateObject var dashboardNav: DashboardNavigation<RoleProfileView>
    
    @Binding var isAuthenticated: Bool
    
    var roleCardView: RoleCardView?
    
    var body: some View {
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
            // UserCardView is the interactive element for user profile
            UserCardView()
                .onTapGesture {
                    navPath.navigationPath.append(dashboardNav.options[0])
                    
                }
                .padding(.bottom, 5)
            
            // RoleCardView (or its placeholder) for role profile
            OptionalView(content: roleCardView)
                .onTapGesture {
                    navPath.navigationPath.append(dashboardNav.options[1])
                }
                .padding(.bottom, 5)
            
            SignOutButton(cvm: cvm)
        }
        .navigationDestination(for: DashboardNavigation.DashboardViewNavigationOptions.self) { option in
            dashboardNav.dashboardViewPaths(item: option)
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

    init(content: Content?) {
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

