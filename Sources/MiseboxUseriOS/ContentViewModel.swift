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
public final class ContentViewModel: ObservableObject {
    private var authStateDidChangeListenerHandle: AuthStateDidChangeListenerHandle?
    public let authenticationManager = AuthenticationManager()
    
    @Published public var miseboxUserManager: MiseboxUserManager
    @Published public var currentUser: AuthenticationManager.FirebaseUser?
    
    init(miseboxUserManager: MiseboxUserManager) {
        self.miseboxUserManager = miseboxUserManager
        Task {
            await authenticate()
            if EnvironmentManager.shared.mode == .development {
                self.isAuthenticated = true
            }
        }
    }

    @Published public var isAuthenticated = false
    @Published var email = "test@test.com"
    @Published var password = "12345678"
    @Published var message: String?
    
    func authenticate() async {
        print("Onboarding[authenticate] Starting authentication process...")
        authStateDidChangeListenerHandle = Auth.auth().addStateDidChangeListener { [weak self] (_, user) in
            Task {
                guard let self = self else { return }
                
                if let user = user {
                    print("Onboarding[authStateDidChangeListener] User found: \(user.uid)")
                    let firebaseUser = AuthenticationManager.FirebaseUser(user: user)
                    self.currentUser = firebaseUser
                    if let currentUser = self.currentUser, currentUser.isAnon {
                        print("Onboarding[authStateDidChangeListener] Is user anonymous: \(firebaseUser.isAnon)")
                        self.isAuthenticated = false
                    } else {
                        self.isAuthenticated = true
                        print("user onboard")
                    }
                } else {
                    print("Onboarding[authStateDidChangeListener] No user found.")
                    self.isAuthenticated = false
                    self.currentUser = nil
                }
            }
        }
    }


    private func primeUserAndProfile(withUID uid: String) async {
        guard !uid.isEmpty else {
            print("UID is empty, cannot prime user and profile.")
            return
        }
        
        await MainActor.run {
            print("Priming both objects with UID: \(uid)")
            self.miseboxUserManager.miseboxUser.prime(id: uid)
            self.miseboxUserManager.miseboxUserProfile.prime(id: uid)
        }
    }
    
    public func onboardMiseboxUser() async {
        
        guard !miseboxUserManager.id.isEmpty else {
            print("Invalid or missing ID for miseboxUserManager.")
            return
        }
        
        do {
            if try await miseboxUserManager.checkMiseboxUserExistsInFirestore() {
                // dispach
                miseboxUserManager.documentListener(for: self.miseboxUserManager.miseboxUser) { result in
                    switch result {
                    case .success(let updatedUser):
                        DispatchQueue.main.async {
                            print("MiseboxUser updated: \(updatedUser.id)")
                            self.miseboxUserManager.documentListener(for: self.miseboxUserManager.miseboxUserProfile, completion: { _ in })
                            print("[Content View Model]\(self.miseboxUserManager.id)")
                        }
                    case .failure(let error):
                        print("Error in document listener: \(error.localizedDescription)")
                    }
                }
            } else {
                print("MiseboxUser with id \(miseboxUserManager.id) Not found")
                Task {
                    try await miseboxUserManager.setMiseboxUserAndProfile()
                }
            }
        } catch { print("Error checking MiseboxUser in Firestore: \(error.localizedDescription)") }
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
        await primeUserAndProfile(withUID: firebaseUser.uid)
        await onboardMiseboxUser()
    }
    
    public func signOut() async {
        miseboxUserManager.reset()
        await authenticationManager.signOut()
        self.isAuthenticated = false
    }
}
        
