//
//  File.swift
//  
//
//  Created by Daniel Watson on 24.02.2024.
//

import Foundation
import MiseboxiOSGlobal

public class MiseboxUserProfileViewNavigation: ObservableObject {
    public init() {}

    public enum MiseboxUserProfileSections: String, CaseIterable, Identifiable {
        case basicInfo = "Basic Information"
        case mediumInfo = "Medium Information"
        case advancedInfo = "Advanced Information"

        public var id: Self { self }

        public var iconName: String {
            switch self {
            case .basicInfo: return "person.fill"
            case .mediumInfo: return "calendar"
            case .advancedInfo: return "gearshape.fill"
            }
        }

        public var displayName: String { self.rawValue }
    }
}

