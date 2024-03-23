//
//  Utilities.swift
//  NavigationStack
//
//  Created by Daniel Watson on 15.03.2024.
//

import Foundation
import SwiftUI
import SwiftUI

public class GlobalNavigation: ObservableObject {
    public enum GlobalRoutes: String, CaseIterable, Identifiable {
        case option1, option2, notifs, chats

        public var id: Self { self }

        public var iconName: String {
            switch self {
            // No icons for option1 and option2
            case .option1, .option2: return ""
            case .notifs: return "bell.fill"
            case .chats: return "message.fill"
            }
        }

        public var displayName: String { rawValue.capitalized }
    }

    public init() {}

    @ViewBuilder
    public func router(route: GlobalRoutes) -> some View {
        switch route {
        case .notifs:
            NotifsView()  // Ensure NotifsView is public
        case .chats:
            ChatsView()  // Ensure ChatsView is public
        default:
            EmptyView()
        }
    }
}

public class NavigationPathObject: ObservableObject {
    @Published public var navigationPath = NavigationPath()
    public init() {}
}

public protocol NavigationSection: RawRepresentable, CaseIterable, Identifiable where RawValue == String {
    var iconName: String { get }
    var displayName: String { get }
}

extension View {
    func navSystem(contentViewNavigation: ContentViewNavigationProtocol) -> some View {
        self.modifier(
            CommonNavigationModifiers(contentViewNavigation: contentViewNavigation)
        )
    }
}

protocol ContentViewNavigationProtocol {
    var option1Label: String { get }
    var option2Label: String { get }
}

struct CommonNavigationModifiers: ViewModifier {
    @EnvironmentObject var navigation: NavigationPathObject
    var contentViewNavigation: ContentViewNavigationProtocol

    func body(content: Content) -> some View {
        content
            .navigationBarBackButtonHidden(true)
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItemGroup(placement: .navigationBarLeading) {
                    if navigation.navigationPath.count == 0 {
                        Menu {
                            Button(contentViewNavigation.option1Label) {
                                navigation.navigationPath = NavigationPath([GlobalNavigation.GlobalRoutes.option1])
                            }
                            Button(contentViewNavigation.option2Label) {
                                navigation.navigationPath = NavigationPath([GlobalNavigation.GlobalRoutes.option2])
                            }
                        } label: {
                            Image(systemName: "star")
                        }
                    } else {
                        CustomBackButton()
                    }
                }
                
                ToolbarItemGroup(placement: .navigationBarTrailing) {
                    Button(action: {
                        navigation.navigationPath = NavigationPath([GlobalNavigation.GlobalRoutes.notifs])
                    }) {
                        Image(systemName: GlobalNavigation.GlobalRoutes.notifs.iconName)
                    }
                    Button(action: {
                        navigation.navigationPath = NavigationPath([GlobalNavigation.GlobalRoutes.chats])
                    }) {
                        Image(systemName: GlobalNavigation.GlobalRoutes.chats.iconName)
                    }
                }
            }
            .transition(.slide)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(.blue)
            .foregroundColor(.orange)
    }
}



struct CustomBackButton: View {
    @EnvironmentObject var navigationPath: NavigationPathObject

    var body: some View {
        Button(action: {
            navigationPath.navigationPath.removeLast()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
}

