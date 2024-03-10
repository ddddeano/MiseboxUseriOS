//
//  MiseboxUserManagerFunctions.swift
//
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import MiseboxiOSGlobal
import FirebaseiOSMisebox


extension MiseboxUserManager {
    
    public func collectionListener(completion: @escaping (Result<[MiseboxUser], Error>) -> Void) {
        print("Adding collection listener for Misebox users...")
        self.listener = firestoreManager.addCollectionListener(collection: self.miseboxUser.collection, completion: completion)
    }

}
