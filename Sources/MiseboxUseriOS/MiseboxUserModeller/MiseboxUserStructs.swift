//
//  MiseboxUserManagerStructs.swift
//
//  Created by Daniel Watson on 22.01.24.
//

import FirebaseFirestore // Import Firestore

extension MiseboxUserManager {
    
    public enum RoleTypes: String, CaseIterable {
        case miseboxUser = "misebox-user"
        case chef = "chef"
        case agent = "agent"
        case recruiter = "recruiter"

        var docCollection: DocCollection {
            switch self {
            case .miseboxUser: return DocCollection(doc: "misebox-user", collection: "misebox-users")
            case .chef: return DocCollection(doc: "chef", collection: "chefs")
            case .agent: return DocCollection(doc: "agent", collection: "agents")
            case .recruiter: return DocCollection(doc: "recruiter", collection: "recruiters")
            }
        }
    }

    public struct UserRole {
        public var docCollection: DocCollection
        public var name: String
        
        public init(docCollection: DocCollection, name: String) {
            self.docCollection = docCollection
            self.name = name
        }
        
        public init?(fire: [String: Any]) {
            let doc = fire["role"] as? String ?? ""
            let name = fire["name"] as? String ?? ""
            
            self.name = name
            self.docCollection = UserRole.docCollection(fromRoleName: doc)
        }
        
        public func toFirestore() -> [String: Any] {
            ["role": docCollection.doc, "name": name]
        }
        
        private static func docCollection(fromRoleName roleName: String) -> DocCollection {
            if let role = RoleTypes(rawValue: roleName) {
                return role.docCollection
            } else {
                print("Unknown role name: \(roleName)")
                return DocCollection(doc: "unknown", collection: "unknown")
            }
        }

        static func updateRolesArray(rolesArray: [[String: Any]], forRoleType roleType: RoleTypes, to newName: String) -> [[String: Any]] {
            rolesArray.map { role -> [String: Any] in
                var modifiedRole = role
                if modifiedRole["role"] as? String == roleType.rawValue {
                    modifiedRole["name"] = newName
                }
                return modifiedRole
            }
        }
        static func updatePersonNameForRole(miseboxId: String, roleType: RoleTypes, to newName: String) async throws {
            let rolesArray = try await StaticFirestoreManager.getDependentArray(forCollection: "misebox-users", documentID: miseboxId, fieldName: "user_roles")
            
            let updatedRoles = updateRolesArray(rolesArray: rolesArray, forRoleType: roleType, to: newName)
            
            let documentRef = StaticFirestoreManager.documentReference(forCollection: "misebox-users", documentID: miseboxId)
            try await documentRef.updateData(["user_roles": updatedRoles])
        }
    }

    public struct FullName {
        public var first = ""
        public var middle = ""
        public var last = ""
        
        public init() {}
        
        public init?(fromDictionary fire: [String: Any]) {
            self.first = fire["first"] as? String ?? ""
            self.middle = fire["middle"] as? String ?? ""
            self.last = fire["last"] as? String ?? ""
        }
        public func toFirestore() -> [String: Any] {
            ["first": first, "middle": middle, "last": last]
        }
    }
    
    public struct Subscription {
        public var type: SubscriptionType = .basic
        public var startDate: Timestamp = Timestamp()
        public var endDate: Timestamp = Timestamp()
        
        public init() {}
        
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

