import Foundation
import FirebaseFirestore
import FirebaseiOSMisebox
import MiseboxiOSGlobal

extension MiseboxUserManager {
    public final class MiseboxUser: ObservableObject, Identifiable, Listenable {
        
        public let doc = "misebox-user"
        public let collection = "misebox-users"
        
        @Published public var id: String = ""
        @Published public var handle: String = ""
        @Published public var imageUrl: String = "" // Essential
        @Published public var verified: Bool = false
        @Published public var fullName = FullName() // Added fullName here
        
        public init() {}
        
        public func prime(id: String) {
            self.id = id
        }
        
        public init?(documentSnapshot: DocumentSnapshot) {
            guard let data = documentSnapshot.data() else { return nil }
            self.id = documentSnapshot.documentID
            update(with: data)
        }
        
        public func update(with data: [String: Any]) {
                   handle = data["handle"] as? String ?? ""
                   imageUrl = data["image_url"] as? String ?? ""
                   verified = data["verified"] as? Bool ?? false
                   self.fullName = fireObject(from: data["full_name"] as? [String: Any] ?? [:], using: FullName.init) ?? FullName()
               }
        
        public func toFirestore() -> [String: Any] {
            [
                "handle": handle,
                "image_url": imageUrl,
                "verified": verified,
                "full_name": fullName.toFirestore(),
            ]
        }
        
        public func resetFields() {
            id = ""
            handle = ""
            imageUrl = ""
            verified = false
            fullName = FullName()
        }
    }
}

extension MiseboxUserManager.MiseboxUser {
    public static var sandboxUser: MiseboxUserManager.MiseboxUser {
        let user = MiseboxUserManager.MiseboxUser()
        user.id = "sandboxUser123"
        user.handle = "johndoe1991"
        user.imageUrl = "https://i.pravatar.cc/300"
        user.verified = true
        user.fullName = MiseboxUserManager.FullName(first: "John", middle: "Q", last: "Doe")
        return user
    }
}

