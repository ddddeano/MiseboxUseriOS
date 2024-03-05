//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//
import SwiftUI
import MiseboxiOSGlobal
import _PhotosUI_SwiftUI

public struct MiseboxUserCard<DashboardVM: DashboardViewModelProtocol>: View {
    @ObservedObject var photoVM: PhotosPickerVM
    @ObservedObject var vm: DashboardVM
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile
    
    public init(photoVM: PhotosPickerVM, vm: DashboardVM) {
        self.photoVM = photoVM
        self.vm = vm
    }
    
    public var body: some View {
        HStack(alignment: .top) {
            leftSide
            VStack(alignment: .leading) {
                MainTopView(title: miseboxUser.handle, subtitle: "@\(miseboxUser.handle)")
                mainBottom
            }
            .padding(.vertical)
        }
        .modifier(ProfileCardStyle())
    }
    
    
    private var mainBottom: some View {
        VStack(alignment: .leading) {
            Text(miseboxUser.subscription.type.rawValue)
                .font(.caption)
                .foregroundColor(.purple.opacity(0.8))
            Text("MiseCODE: \(miseboxUser.miseCODE)")
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

