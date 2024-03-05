//
//  File.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

public class UserProfileViewNavigation: ObservableObject {
    public init() {}
    
    public enum ProfileSections: String, CaseIterable, Identifiable, RawRepresentable, ProfileSection {
        case basicInfo = "Basic Information"
        case mediumInfo = "Medium Information"
        case advancedInfo = "Advanced Information"
        
        public var id: Self { self }
        
        public var iconName: String {
            switch self {
            case .basicInfo: return "house.fill"
            case .mediumInfo: return "person.3.fill"
            case .advancedInfo: return "gear"
            }
        }
        
        public var displayName: String { self.rawValue }
        
        @ViewBuilder
        public func view<DashboardVM: DashboardViewModelProtocol>(vm: DashboardVM) -> some View {
            switch self {
            case .basicInfo:
                BasicInfoView(vm: vm)
            case .mediumInfo:
                MediumInfoView(vm: vm)
            case .advancedInfo:
                AdvancedInfoView(vm: vm)
            }
        }
    }
}

public struct MiseboxUserProfile<DashboardVM: DashboardViewModelProtocol>: View {
    @ObservedObject var vm: DashboardVM
    @StateObject var nav = UserProfileViewNavigation()
    @Binding var navigationPath: NavigationPath
    
    public init(vm: DashboardVM, navigationPath: Binding<NavigationPath>) {
        self._vm = ObservedObject(wrappedValue: vm)
        self._nav = StateObject(wrappedValue: UserProfileViewNavigation())
        self._navigationPath = navigationPath
    }

    let sections: [UserProfileViewNavigation.ProfileSections] = [.basicInfo, .mediumInfo, .advancedInfo]

    public var body: some View {
        ProfileView(sections: sections) { section in
            section.view(vm: vm)
        }
    }
}


