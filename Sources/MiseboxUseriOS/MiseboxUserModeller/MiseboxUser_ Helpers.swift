//
//  Helpers.swift
//
//
//  Created by Daniel Watson on 10.03.2024.
//
import Firebase
import Foundation
import MiseboxiOSGlobal
import FirebaseiOSMisebox


extension MiseboxUserManager {
    
    public func generateMiseCODE() async -> String {
        let characters = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
        var miseCODE: String
        var isUnique: Bool
        
        repeat {
            let randomCharacters = (0..<6).map { _ in characters.randomElement()! }
            miseCODE = "MISO" + String(randomCharacters)
            isUnique = await checkMiseCODEIsUnique(miseCODE: miseCODE)
        } while !isUnique
        
        return miseCODE
    }
    
    private func checkMiseCODEIsUnique(miseCODE: String) async -> Bool {
        do {
            return try await firestoreManager.isFieldValueUnique(inCollection: "misebox-users", fieldName: "miseCODE", fieldValue: miseCODE)
        } catch {
            print("Error checking uniqueness of miseCODE: \(error)")
            return false
        }
    }
    
    public func generateHandle(firebaseUser: AuthenticationManager.FirebaseUser) async -> String {
        var rawHandle: String = ""
        
        switch firebaseUser.provider {
        case .email:
            if let email = firebaseUser.email, let prefix = email.components(separatedBy: "@").first {
                rawHandle = prefix
            }
        default:
            if let name = firebaseUser.name, !name.isEmpty {
                rawHandle = name
            }
        }
        
        let baseHandle = rawHandle.replacingOccurrences(of: " ", with: "").lowercased()
        return await generateUniqueHandle(baseHandle: baseHandle)
    }
    
    private func generateUniqueHandle(baseHandle: String) async -> String {
        var uniqueHandle = baseHandle
        var suffix = 1
        var isUnique = false
        
        repeat {
            isUnique = await checkHandleIsUnique(handle: uniqueHandle)
            if !isUnique {
                uniqueHandle = "\(baseHandle)\(suffix)"
                suffix += 1
            }
        } while !isUnique
        
        return uniqueHandle
    }
    
    private func checkHandleIsUnique(handle: String) async -> Bool {
        do {
            return try await firestoreManager.isFieldValueUnique(inCollection: "misebox-users", fieldName: "handle", fieldValue: handle)
        } catch {
            print("Error checking uniqueness of handle: \(error)")
            return false
        }
    }
}
