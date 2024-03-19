import SwiftUI
import FirebaseiOSMisebox
import Firebase
import MiseboxiOSGlobal

public protocol RoleProfileViewProtocol: View {}

// Marking the class and its initializer as public
public class DashboardNavigation<RoleProfileView: RoleProfileViewProtocol>: ObservableObject {
    
    var options: [DashboardRoutes] = [.user, .role]
    
    enum DashboardRoutes: String, CaseIterable, Identifiable, NavigationSection {
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

    public init(roleProfileView: RoleProfileView) {
        self.roleProfileView = roleProfileView
    }
    
    @ViewBuilder
    func router(item: DashboardRoutes) -> some View {
        switch item {
        case .user:
            Text("MiseboxUserProfile()")
        case .role:
            roleProfileView
        }
    }
}

public struct Dashboard<RoleManagerType: RoleManager, RoleProfileView: RoleProfileViewProtocol>: View {
    @EnvironmentObject var navPath: NavigationPathObject
    @ObservedObject public var cvm: ContentViewModel<RoleManagerType>
    @StateObject public var dashboardNav: DashboardNavigation<RoleProfileView>
    @Binding public var isAuthenticated: Bool

    public init(cvm: ContentViewModel<RoleManagerType>, dashboardNav: DashboardNavigation<RoleProfileView>, isAuthenticated: Binding<Bool>) {
        self._cvm = ObservedObject(wrappedValue: cvm)
        self._dashboardNav = StateObject(wrappedValue: dashboardNav)
        self._isAuthenticated = isAuthenticated
    }
    
    public var body: some View {
        VStack {
            // Clickable text view to test user info navigation
            Text("Click to navigate - User Info Placeholder")
                .onTapGesture {
                    navPath.navigationPath.append(dashboardNav.options[0])
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.bottom, 5)
            
            // Button to test role profile navigation
            Button(action: {
                navPath.navigationPath.append(dashboardNav.options[1])
            }) {
                Text("Click to navigate - Role Profile Placeholder")
                    .frame(maxWidth: .infinity)
                    .background(Color.green)
                    .cornerRadius(10)
            }
            .padding(.bottom, 5)
        }
        .navigationDestination(for: DashboardNavigation.DashboardRoutes.self) { route in
            dashboardNav.router(item: route)
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
