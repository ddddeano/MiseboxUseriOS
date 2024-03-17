//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//
import SwiftUI
import MiseboxiOSGlobal
import _PhotosUI_SwiftUI

public protocol CardViewProtocol: View {
}

public struct MiseboxUserCard: CardViewProtocol, View {
    @Binding public var navigationPath: NavigationPath
    @ObservedObject var photoVM: PhotosPickerVM
    @EnvironmentObject var miseboxUserManager: MiseboxUserManager
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    public init(photoVM: PhotosPickerVM, navigationPath: Binding<NavigationPath>) {
        self.photoVM = photoVM
        self._navigationPath = navigationPath
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            leftSide
            VStack(alignment: .leading) {
                MainTopView(title: miseboxUserManager.nameFirstAndLast, subtitle: "@\(miseboxUser.handle)")
                mainBottom
            }
            .padding(.vertical)
        }
        .modifier(ProfileCardStyle())
    }
    
    private var mainBottom: some View {
        VStack(alignment: .leading) {
            Text(miseboxUserProfile.subscription.type.rawValue)
                .font(.caption)
                .foregroundColor(.purple.opacity(0.8))
            Text("MiseCODE: \(miseboxUserProfile.miseCODE)")
                .font(.caption)
                .foregroundColor(.purple.opacity(0.8))
        }
    }
    
    private var leftSide: some View {
        VStack {
            PhotosPicker(selection: $photoVM.imageSelection, matching: .images) {
                Group {
                    if miseboxUser.imageUrl.isEmpty {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                    } else {
                        AvatarView(imageUrl: miseboxUser.imageUrl, width: 60, height: 60, kind: .edit)
                    }
                }
                .frame(width: 60, height: 60)
                .contentShape(Rectangle())
            }
        }
        .padding(15)
    }
}
