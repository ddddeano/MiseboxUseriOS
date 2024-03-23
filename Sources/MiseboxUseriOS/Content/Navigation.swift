//
//  Utilities.swift
//  NavigationStack
//
//  Created by Daniel Watson on 15.03.2024.
//

import Foundation
import SwiftUI
import MiseboxiOSGlobal

public class GlobalNavigation: ObservableObject {
    public enum Routes: String, CaseIterable, Identifiable {
        case option1, option2, notifs, chats

        public var id: Self { self }

        public var iconName: String {
            switch self {
            case .option1, .option2: return ""
            case .notifs: return "bell.fill"
            case .chats: return "message.fill"
            }
        }

        public var displayName: String { rawValue.capitalized }
    }

    public init() {}

    @ViewBuilder
    public func router(route: Routes) -> some View {
        switch route {
        case .notifs:
            NotifsView()
        case .chats:
            ChatsView()
        default:
            EmptyView()
        }
    }
}

public class NavigationPathObject: ObservableObject {
    @Published public var route = NavigationPath()
    public init() {}
}

public protocol NavigationSection: RawRepresentable, CaseIterable, Identifiable where RawValue == String {
    var iconName: String { get }
    var displayName: String { get }
}

public protocol ContentViewNavigationProtocol {
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
                    if navigation.route.count == 0 {
                        Menu {
                            Button(contentViewNavigation.option1Label) {
                                navigation.route = NavigationPath([GlobalNavigation.Routes.option1])
                            }
                            Button(contentViewNavigation.option2Label) {
                                navigation.route = NavigationPath([GlobalNavigation.Routes.option2])
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
                        navigation.route = NavigationPath([GlobalNavigation.Routes.notifs])
                    }) {
                        Image(systemName: GlobalNavigation.Routes.notifs.iconName)
                    }
                    Button(action: {
                        navigation.route = NavigationPath([GlobalNavigation.Routes.chats])
                    }) {
                        Image(systemName: GlobalNavigation.Routes.chats.iconName)
                    }
                }
            }
            .transition(.slide)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(Env.env.appDark)
            .foregroundColor(Env.env.appLight)
    }
}



struct CustomBackButton: View {
    @EnvironmentObject var navigationPath: NavigationPathObject

    var body: some View {
        Button(action: {
            navigationPath.route.removeLast()
        }) {
            HStack {
                Image(systemName: "chevron.left")
                Text("Back")
            }
        }
    }
}


public extension View {
    func navSystem(contentViewNavigation: ContentViewNavigationProtocol) -> some View {
        self.modifier(
            CommonNavigationModifiers(contentViewNavigation: contentViewNavigation)
        )
    }
}

 
