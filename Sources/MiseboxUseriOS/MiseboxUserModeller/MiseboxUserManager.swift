//
//  MiseboxUserManager.swift
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import FirebaseFirestore
import FirebaseiOSMisebox

@MainActor
public final class MiseboxUserManager: ObservableObject {
    public var role: MiseboxUserManager.Role
    
    let firestoreManager = FirestoreManager()
    
    public var listener: ListenerRegistration?
    deinit {
        listener?.remove()
    }
    
    public var ecosystemData: EcosystemData?
    
    @Published public var miseboxUser = MiseboxUser()
    @Published public var miseboxUserProfile = MiseboxUserProfile()
    
    public init(role: MiseboxUserManager.Role) {
        self.role = role
        Task {
            self.fetchEcosystemData()
        }
    }
    
    private func fetchEcosystemData() {
        firestoreManager.fetchDataDocument(collection: "ecosystem", documentID: "data") { [weak self] (result: Result<EcosystemData, Error>) in
            DispatchQueue.main.async {
                guard let self = self else { return }
                switch result {
                case .success(let data):
                    self.ecosystemData = data
                case .failure(let error):
                    print("Error fetching ecosystem data: \(error)")
                }
            }
        }
    }
    public func reset() {
        listener?.remove()
        self.miseboxUser = MiseboxUser()
        self.miseboxUserProfile = MiseboxUserProfile()
    }
}

public protocol CanMiseboxUser {
    var authenticationManager: AuthenticationManager { get }
    var miseboxUserManager: MiseboxUserManager { get }
     func onboardMiseboxUser() async
}

public final class EcosystemData: FirestoreDataProtocol {
    public var id = ""
    public var miseboxUserMotto = ""
    public var chefMotto = ""
    public var agentMotto = ""
    public var recruiterMotto = ""

    public init() {}
    
    public required init?(documentSnapshot: DocumentSnapshot) {
        guard let data = documentSnapshot.data() else { return nil }
        self.miseboxUserMotto = data["miseboxUserMotto"] as? String ?? ""
        self.chefMotto = data["chefMotto"] as? String ?? ""
        self.agentMotto = data["agentMotto"] as? String ?? ""
        self.recruiterMotto = data["recruiterMotto"] as? String ?? ""
    }

    public func update(with data: [String: Any]) {
        // Implementation if needed, could be empty for EcosystemData
    }
}

