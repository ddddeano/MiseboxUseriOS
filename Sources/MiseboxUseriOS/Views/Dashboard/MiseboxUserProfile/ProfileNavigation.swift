//
//  File.swift
//  
//
//  Created by Daniel Watson on 06.03.2024.
//

import Foundation
import SwiftUI

import Foundation
import SwiftUI

public protocol ProfileSection: CaseIterable, Identifiable, Hashable, RawRepresentable where RawValue == String {
    var iconName: String { get }
    var displayName: String { get }
}

public class MiseboxUserProfileViewNavigation: ObservableObject {
    public init() {}

    public enum Route: String, CaseIterable, Identifiable, ProfileSection {
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

    @ViewBuilder
    func router(_ route: Route) -> some View {
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

