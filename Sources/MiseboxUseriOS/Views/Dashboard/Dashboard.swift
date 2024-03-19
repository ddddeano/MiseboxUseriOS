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
            MiseboxUserProfile()
        case .role:
            roleProfileView
        }
    }
}

struct Dashboard<RoleManagerType: RoleManager, RoleProfileView: RoleProfileViewProtocol>: View {
    @EnvironmentObject var navPath: NavigationPathObject
    @ObservedObject var cvm: ContentViewModel<RoleManagerType>
    @StateObject var dashboardNav: DashboardNavigation<RoleProfileView>
    @Binding var isAuthenticated: Bool

    public init(cvm: ContentViewModel<RoleManagerType>, dashboardNav: DashboardNavigation<RoleProfileView>, isAuthenticated: Binding<Bool>) {
        self._cvm = ObservedObject(wrappedValue: cvm)
        self._dashboardNav = StateObject(wrappedValue: dashboardNav)
        self._isAuthenticated = isAuthenticated
    }
    
    public var body: some View {
        VStack {
            // Simple Text view as a placeholder for the user card
            Text("User Info Placeholder")
                .onTapGesture {
                    navPath.navigationPath.append(dashboardNav.options[0])
                }
                .padding()
                .frame(maxWidth: .infinity)
                .background(Color.blue)
                .cornerRadius(10)
                .padding(.bottom, 5)
            
            Button(action: {
                navPath.navigationPath.append(dashboardNav.options[1])
            }) {
                dashboardNav.roleProfileView
                    .frame(maxWidth: .infinity)
                    .background(Color.blue)
                    .cornerRadius(10)
            }
            .padding(.bottom, 5)
            
            SignOutButton(cvm: cvm)
        }
        .navigationDestination(for: DashboardNavigation.DashboardRoutes.self) { route in
            dashboardNav.router(item: route)
        }
    }
    
    public struct SignOutButton: View {
        @ObservedObject var cvm: ContentViewModel<RoleManagerType>
        
        public var body: some View {
            Button("Sign Out") {
                Task {
                    await cvm.signOut()
                }
            }
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
