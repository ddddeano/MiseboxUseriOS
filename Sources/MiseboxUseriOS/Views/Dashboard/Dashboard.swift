
//
//  [MiseboxUseriOS]Dashboard.swift
//  MiseboxUseriOS
//
//  Created by Daniel Watson on 26.02.2024.
//

import SwiftUI
import FirebaseiOSMisebox
import Firebase
import MiseboxiOSGlobal

protocol RoleProfileView: View {}

protocol RoleCardView: View {}

struct Dashboard<RoleManagerType: RoleManager, ProfileView: RoleProfileView, CardView: RoleCardView>: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @ObservedObject var vm: DashboardVM
    @ObservedObject var cvm: ContentViewModel<RoleManagerType>
    
    @Binding var navigationPath: NavigationPath
    @Binding var isAuthenticated: Bool
    
    let profileView: ProfileView
    let cardView: CardView
    
    var body: some View {
        if cvm.isAnon {
            anonView
        } else {
            dashboardView
        }
    }
    
    private var anonView: some View {
        AnonymousUserCard(isAuthenticated: $isAuthenticated)
    }

    private var dashboardView: some View {
        VStack {
            NavigationLink(destination: MiseboxUserProfile(vm: vm, navigationPath: $navigationPath)) {
                MiseboxUserCard(
                    photoVM: PhotosPickerVM(
                        path: "misebox-users/avatars/\(miseboxUser.miseCODE)",
                        documentId: miseboxUser.id,
                        collectionName: miseboxUser.collection),
                    vm: vm
                )
            }
            .padding()
            NavigationLink(destination: profileView) {
                cardView
            }
            .padding()
            
            Button("Sign Out") {
                Task {
                    await vm.signOut()
                }
            }
            .foregroundColor(.red)
            .padding()
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color.red, lineWidth: 2)
            )
        }
    }
}
