import SwiftUI
import FirebaseiOSMisebox
import Firebase
import MiseboxiOSGlobal

public protocol RoleProfileViewProtocol: View {}

public class DashboardNavigation<RoleProfileView: RoleProfileViewProtocol>: ObservableObject {
    
    public var options: [DashboardRoutes] = [.user, .role]
    
    public enum DashboardRoutes: String, CaseIterable, Identifiable, NavigationSection {
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
    
    var roleProfileView: RoleProfileView

    public init(roleProfileView: RoleProfileView) {
        self.roleProfileView = roleProfileView
    }
    
    @MainActor @ViewBuilder
    public func router(item: DashboardRoutes) -> some View {
        switch item {
        case .user:
            MiseboxUserProfile()
        case .role:
            roleProfileView
        }
    }
}


public struct Dashboard<RoleManagerType: RoleManager, RoleProfileView: RoleProfileViewProtocol, RoleCardView: View>: View {
    @EnvironmentObject var navPath: NavigationPathObject
    @ObservedObject var cvm: ContentViewModel<RoleManagerType>
    @StateObject var dashboardNav: DashboardNavigation<RoleProfileView>
    
    let userCard: MiseboxUserCard
    let roleCardView: RoleCardView?
    
    public init(cvm: ContentViewModel<RoleManagerType>, dashboardNav: DashboardNavigation<RoleProfileView>, userCard: MiseboxUserCard, roleCardView: RoleCardView? = nil) {
        self._cvm = ObservedObject(wrappedValue: cvm)
        self._dashboardNav = StateObject(wrappedValue: dashboardNav)
        self.userCard = userCard
        self.roleCardView = roleCardView
    }
    
    public var body: some View {
        VStack {
            userCard
                .onTapGesture {
                    navPath.navigationPath.append(dashboardNav.options[0])
                }
                .padding(.bottom, 5)
            
            if let roleCard = roleCardView {
                roleCard
                    .onTapGesture {
                        navPath.navigationPath.append(dashboardNav.options[1])
                    }
                    .padding(.bottom, 5)
            }
            
            Button("Sign Out") { Task { await cvm.signOut() } }
                .foregroundColor(.red)
                .padding()
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.red, lineWidth: 2))
        }
        .navigationDestination(for: DashboardNavigation.DashboardRoutes.self) { option in
            dashboardNav.router(item: option)
        }
        .environmentObject(navPath)
    }
}

