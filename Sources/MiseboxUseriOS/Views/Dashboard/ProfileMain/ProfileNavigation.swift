//
//  File.swift
//  
//
//  Created by Daniel Watson on 06.03.2024.
//

import Foundation
import SwiftUI

public protocol ProfileSection: CaseIterable, Identifiable, Hashable, RawRepresentable where RawValue == String {
    var iconName: String { get }
    var displayName: String { get }
}

public class UserProfileViewNavigation: ObservableObject {
    public init() {}

    public enum ProfileSections: String, CaseIterable, Identifiable, RawRepresentable, ProfileSection {
        case personalInfo = "Personal Information"
        case contactInfo = "Contact Information"
        case additionalInfo = "Additional Information"

        public var id: Self { self }

        public var iconName: String {
            switch self {
            case .personalInfo: return "person.fill"
            case .contactInfo: return "envelope.fill"
            case .additionalInfo: return "gear"
            }
        }

        public var displayName: String { self.rawValue }

        @ViewBuilder
        public func view() -> some View {
            switch self {
            case .personalInfo:
                UserInfoView()
            case .contactInfo:
                ContactInfoView()
            case .additionalInfo:
                AdditionalInfoView()
            }
        }
    }
}
