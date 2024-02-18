//
//  MiseboxUserManagerStructs.swift
//
//  Created by Daniel Watson on 22.01.24.
//

import FirebaseFirestore
import GlobalMiseboxiOS
import FirebaseiOSMisebox
import SwiftUI

extension MiseboxUserManager {
    public struct Role {
        public let doc: String
        public let collection: String
        public let color: Color
        public let isAvailable: Bool
        
        // Define roles without the 'mottoKey' property
        public static let miseboxUser = Role(doc: "misebox-user", collection: "misebox-users", color: .purple, isAvailable: true)
        public static let chef = Role(doc: "chef", collection: "chefs", color: .green, isAvailable: true)
        public static let agent = Role(doc: "agent", collection: "agents", color: .blue, isAvailable: true)
        public static let recruiter = Role(doc: "recruiter", collection: "recruiters", color: .orange, isAvailable: true)
        
        public static let allCases: [Role] = [.miseboxUser, .chef, .agent, .recruiter]
        
        // Helper method to find a role by its document identifier
        public static func find(byDoc doc: String) -> Role? {
            return allCases.first { $0.doc == doc }
        }
    }
    
    public struct UserRole {
        public var role: Role
        public var handle: String
        
        public init(role: Role, handle: String) {
            self.role = role
            self.handle = handle
        }
        
        public init?(data: [String: Any]) {
            guard let doc = data["role"] as? String,
                  let handle = data["handle"] as? String,
                  let foundRole = Role.find(byDoc: doc) else {
                return nil
            }
            self.role = foundRole
            self.handle = handle
        }
        
        public func toFirestore() -> [String: Any] {
            ["role": role.doc, "handle": handle]
        }
        
        public static func updateHandle(userId: String, roleDoc: String, newHandle: String) async throws {
            try await StaticFirestoreManager.updateArray(
                collection: "misebox-users",
                documentID: userId,
                arrayName: "user_roles",
                matchKey: "role",
                matchValue: roleDoc,
                updateKey: "handle",
                newValue: newHandle
            )
        }
    }
    
    public struct FullName {
        public var first = ""
        public var middle = ""
        public var last = ""
        
        public init() {}
        public init(first: String, middle: String, last: String) {
            self.first = first
            self.middle = middle
            self.last = last
        }
        
        public init?(fromDictionary fire: [String: Any]) {
            self.first = fire["first"] as? String ?? ""
            self.middle = fire["middle"] as? String ?? ""
            self.last = fire["last"] as? String ?? ""
        }
        public func toFirestore() -> [String: Any] {
            ["first": first, "middle": middle, "last": last]
        }
        var formattedCard: String {
            [first, middle, last].filter { !$0.isEmpty }.joined(separator: " ")
        }
        var isincomplete: Bool {
            first.isEmpty || last.isEmpty
        }
        public var formatted: String {
            [first, middle, last].filter { !$0.isEmpty }.joined(separator: " ")
        }
    }
    
    public struct Subscription {
        public var type: SubscriptionType = .basic
        public var startDate: Timestamp = Timestamp()
        public var endDate: Timestamp = Timestamp()
        
        public init() {}
        public init(type: SubscriptionType) {
            self.type = type
        }
        
        public init?(fromDictionary fire: [String: Any]) {
            self.type = SubscriptionType(rawValue: fire["type"] as? String ?? "") ?? .basic
            self.startDate = fire["start_date"] as? Timestamp ?? Timestamp()
            self.endDate = fire["end_date"] as? Timestamp ?? Timestamp()
        }
        
        public func toFirestore() -> [String: Any] {
            [ "type": type.rawValue, "start_date": startDate, "end_date": endDate]
        }
        public enum SubscriptionType: String {
            case basic
            case trial
            case premium
        }
    }
}

