//
//  Onboarding.swift
//  MiseboxUseriOS
//
//  Created by Daniel Watson on 15.02.2024.
//

import Foundation
import SwiftUI
import FirebaseiOSMisebox
import MiseboxiOSGlobal

public protocol ContentViewProtocol: View {
    associatedtype RoleManagerType: RoleManager
    init(vm: ContentViewModel<RoleManagerType>)
}

struct AuthenticationView<ContentView: ContentViewProtocol>: View where ContentView.RoleManagerType: RoleManager {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    @StateObject var vm: ContentViewModel<ContentView.RoleManagerType>

    var body: some View {
        ZStack {
            if vm.isAuthenticated {
                ContentView(vm: vm)
                    .transition(.opacity.animation(.interpolatingSpring(stiffness: 50, damping: 10)))
            } else {
                LogInView(vm: vm)
                    .transition(.opacity.animation(.interpolatingSpring(stiffness: 50, damping: 10)))
                logo
                    .transition(.opacity.animation(.interpolatingSpring(stiffness: 50, damping: 10)))
            }
        }
        .edgesIgnoringSafeArea(.all)
    }

    var logo: some View {
        Image("LogoType")
            .resizable()
            .scaledToFit()
            .frame(width: 300, height: 100)
            .offset(y: -200)
    }
}


public struct LogInView<RoleManagerType: RoleManager>: View {
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var env: EnvironmentManager
    @ObservedObject var vm: ContentViewModel<RoleManagerType>
    @State private var showEmailSignIn = false
    @State private var errorMessage: String? = ""
    @State private var welcomeIndex = 0
    @State private var slideOutDirection: Edge = .trailing
    @State private var slideInDirection: Edge = .leading
    @State private var animateOut = false
    
    public init(vm: ContentViewModel<RoleManagerType>) {
            self.vm = vm
        }
    
    public var body: some View {
        VStack {
            skip.padding(.top, 50)
            Spacer()
            VStack(spacing: 20) {
                animatedWelcome
                    .frame(maxHeight: 150) // Fixed height for the text area
                    .onAppear {
                        animateMessages()
                    }
                buttonSection
                Text(errorMessage ?? "")
                    .foregroundColor(.yellow)
                    .padding()
                    .opacity(errorMessage == nil ? 0 : 1)
            }
            .padding(.horizontal)
            .padding(.top, 100)
            Spacer()
        }
        .padding()
        .sheet(isPresented: $showEmailSignIn) {
            EmailSignInView(vm: vm)
        }
    }
    private var messages: [String] {
           [env.welcome, env.motto, env.smallPrint]
       }
    var animatedWelcome: some View {
        
        
        return Text(messages[welcomeIndex])
            .font(.title)
            .fontWeight(.bold)
            .padding(.horizontal, 20)
            .foregroundColor(Env.env.appLight)
            .multilineTextAlignment(.center)
            .transition(.asymmetric(insertion: .move(edge: .leading), removal: .move(edge: .trailing)))
            .id(welcomeIndex)
        
    }
    func animateMessages() {
        Timer.scheduledTimer(withTimeInterval: 3, repeats: true) { _ in
            withAnimation {
                welcomeIndex = (welcomeIndex + 1) % messages.count
            }
        }
    }

    var skip: some View {
        Text("Skip")
            .underline()
            .foregroundColor(Env.env.appLight)
            .onTapGesture {
                Task {
                    try? await vm.verifyMiseboxUser(with: .anon)
                }
            }
    }
    
    var buttonSection: some View {
        HStack(spacing: 60) {
            CircleButton(iconType: .asset("google-icon"), size: 50, background: Env.env.appDark.opacity(0.2), foregroundColor: Env.env.appDark, strokeColor: .primary, action: {
                Task {
                    try await vm.verifyMiseboxUser(with: .google)
                }
            })
            CircleButton(iconType: .system("envelope.fill"), size: 50, background: colorScheme == .dark ? .black : .white, foregroundColor: Env.env.appDark, strokeColor: .primary, action: {
                showEmailSignIn = true
            })
            CircleButton(iconType: .asset("apple-icon"), size: 50, background: Env.env.appDark.opacity(0.2), foregroundColor: Env.env.appDark, strokeColor: .primary, action: {
                Task {
                    try await vm.verifyMiseboxUser(with: .apple)
                }
            })
        }
    }
}


struct EmailSignInView<RoleManagerType: RoleManager>: View {
    @Environment(\.colorScheme) var colorScheme
    @ObservedObject var vm: ContentViewModel<RoleManagerType>
    @State private var userIntent: AuthenticationManager.UserIntent = .newUser
    
    var body: some View {
        VStack {
            Image("LogoType")
                .resizable()
                .scaledToFit()
                .frame(width: 150, height: 50)
                .padding(40)
            Picker("User Type", selection: $userIntent) {
                Text("New User").tag(AuthenticationManager.UserIntent.newUser)
                Text("Returning User").tag(AuthenticationManager.UserIntent.returningUser)
            }
            .pickerStyle(SegmentedPickerStyle())
            .padding(12)
            .accentColor(Env.env.appDark)
            .cornerRadius(8)
            .foregroundColor(Env.env.appDark.opacity(0.2))
            
            TextField("Email", text: $vm.email)
                .customInput(backgroundColor: Env.env.appDark.opacity(0.2), requiredBorderColor: .red, defaultBorderColor: Env.env.appDark)
            
            SecureField("Password", text: $vm.password)
                .customInput(backgroundColor: Env.env.appDark.opacity(0.2), requiredBorderColor: .red, defaultBorderColor: Env.env.appDark)
            
            CircleButton(iconType: .system("envelope.fill"), size: 50, background: colorScheme == .dark ? .black : .white, foregroundColor: Env.env.appDark, strokeColor: Env.env.appDark, action: {
                Task {
                    try await vm.verifyMiseboxUser(with: .email, intent: userIntent)
                }
            })
            Spacer()
        }
        .pageStyle(backgroundColor: Env.env.appDark.opacity(0.1))
    }
}
