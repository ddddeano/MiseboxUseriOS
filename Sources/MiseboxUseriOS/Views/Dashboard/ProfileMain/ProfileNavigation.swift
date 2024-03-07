//
//  File.swift
//  
//
//  Created by Daniel Watson on 06.03.2024.
//

import Foundation
import SwiftUI
// Poss move to package
public protocol ProfileSection: CaseIterable, Identifiable, Hashable, RawRepresentable where RawValue == String {
    var iconName: String { get }
    var displayName: String { get }
}

public class UserProfileViewNavigation: ObservableObject {
    public init() {}
    
    public enum ProfileSections: String, CaseIterable, Identifiable, RawRepresentable, ProfileSection {
        case basicInfo = "Basic Information"
       // case mediumInfo = "Medium Information"
       // case advancedInfo = "Advanced Information"
        
        public var id: Self { self }
        
        public var iconName: String {
            switch self {
            case .basicInfo: return "house.fill"
          //  case .mediumInfo: return "person.3.fill"
           // case .advancedInfo: return "gear"
            }
        }
        
        public var displayName: String { self.rawValue }
        
        @ViewBuilder
        public func view() -> some View {
            switch self {
            case .basicInfo:
                Text("BasicInfoView")
           // case .mediumInfo:
             //   MediumInfoView(vm: vm)
            //case .advancedInfo:
             //   AdvancedInfoView(vm: vm)
            }
        }
    }
}
