//
//  ContentViewModel.swift
//  MiseboxUseriOS

//  Logging Format: "Onboarding[functionName] statement content"
//  Created by Daniel Watson on 10.12.23.
// Agent

import Foundation
import MiseboxiOSGlobal
import FirebaseiOSMisebox
import Firebase

@MainActor
public class ContentViewModel<RoleManagerType: RoleManager>: ObservableObject {
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    public let authenticationManager = AuthenticationManager()
    
    @Published public var miseboxUserManager: MiseboxUserManager
    
    @Published public var roleManager: RoleManagerType
    
    @Published public var currentUser: AuthenticationManager.FirebaseUser?
    
    public init(miseboxUserManager: MiseboxUserManager, roleManager: RoleManagerType) {
        self.miseboxUserManager = miseboxUserManager
        self.roleManager = roleManager
        Task {
            await authenticate()
            if EnvironmentManager.env.mode == .development {
                self.isAuthenticated = true
            }
        }
    }

    @Published public var isAuthenticated = false
    @Published public var email = "test@test.com"
    @Published public var password = "12345678"
    @Published public var message: String?
    
    public var isAnon: Bool {
        currentUser?.isAnon ?? false
    }
    
    func authenticate() async {
        print("Onboarding[authenticate] Starting authentication process...")
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            Task {
                guard let self = self else {
                    print("Onboarding[authenticate] self is nil")
                    return
                }
                
                if let user = user {
                    print("Onboarding[authStateDidChangeListener] User found: \(user.uid)")
                    let firebaseUser = AuthenticationManager.FirebaseUser(user: user)
                    self.currentUser = firebaseUser
                    if let currentUser = self.currentUser, currentUser.isAnon {
                        print("Onboarding[authStateDidChangeListener] User is anonymous: \(firebaseUser.isAnon)")
                        self.isAuthenticated = false
                    } else {
                        print("Onboarding[authStateDidChangeListener] User is authenticated, starting onboarding...")
                        self.isAuthenticated = true
                        Task {
                            await self.miseboxUserManager.onboardMiseboxUser()
                        }
                    }
                } else {
                    print("Onboarding[authStateDidChangeListener] No user found, user is not authenticated.")
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
            }
        }
    }

    
    public func verifyMiseboxUser(with method: AuthenticationManager.AuthenticationMethod, intent: AuthenticationManager.UserIntent? = nil) async throws {
        do {
            switch method {
            case .google:
                try await verifyWithGoogle()
            case .apple:
                try await verifyWithApple()
            case .email:
                if let intent = intent {
                    try await verifyWithEmail(email: email, password: password, intent: intent)
                }
            case .anon:
                await signInAnon()
            }
            self.isAuthenticated = true
        } catch {
            print("Error in account verification: \(error.localizedDescription)")
            throw error
        }
    }
    
    @MainActor
    private func signInAnon() async {
        self.currentUser = try? await authenticationManager.signInAnon()
    }
    
    @MainActor
    private func verifyWithEmail(email: String, password: String, intent: AuthenticationManager.UserIntent) async throws {
        let firebaseUser = try await authenticationManager.processWithEmail(email: email, password: password, intent: intent)
        await updateAndOnboardUser(provider: .email, firebaseUser: firebaseUser)
    }
    
    @MainActor
    private func verifyWithGoogle() async throws {
        let helper = SignInGoogleHelper()
        let tokens = try await helper.signIn()
        let firebaseUser = try await authenticationManager.processWithGoogle(tokens: tokens)
        await updateAndOnboardUser(provider: .google, firebaseUser: firebaseUser)
    }
    
    @MainActor
    private func verifyWithApple() async throws {
        let appleSignInResult = try await SignInAppleHelper().startSignInWithAppleFlow()
        let firebaseUser = try await authenticationManager.processWithApple(tokens: appleSignInResult)
        await updateAndOnboardUser(provider: .apple, firebaseUser: firebaseUser)
    }
    
    @MainActor
     private func updateAndOnboardUser(provider: AuthenticationManager.AuthenticationMethod, firebaseUser: AuthenticationManager.FirebaseUser) async {
         self.currentUser = firebaseUser
         await miseboxUserManager.updateUserInfo(provider: provider, firebaseUser: firebaseUser)
     }
    public func signOut() async {
        miseboxUserManager.reset()
        await authenticationManager.signOut()
        self.isAuthenticated = false
    }
}
        
