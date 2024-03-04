//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 23.02.2024.
//

import SwiftUI
import MiseboxiOSGlobal
import _PhotosUI_SwiftUI

public struct UserCardView<DashboardVM: DashboardViewModelProtocol>: View {
    @ObservedObject var photoVM: PhotosPickerVM
    @ObservedObject var vm: DashboardVM
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @EnvironmentObject var miseboxUserProfile: MiseboxUserManager.MiseboxUserProfile

    public init(photoVM: PhotosPickerVM, vm: DashboardVM) {
           self.photoVM = photoVM
           self.vm = vm
       }
    
   public var body: some View {
          HStack {
              leftSide
              main
          }
        .frame(height: 110)
        .sectionStyle(borderColor: .purple)
      }

    private var main: some View {
        VStack(alignment: .leading) {
            Text(miseboxUserProfile.fullName.formattedCard)
                .font(.headline)
                .foregroundColor(.primary)
            Text("@\(miseboxUser.handle)")
                .font(.subheadline)
                .foregroundColor(.purple.opacity(1))
            Divider()
            Text("\(miseboxUserProfile.subscription.type.rawValue) subscription")
                .font(.caption)
                .foregroundColor(.purple.opacity(0.8))
            Text("MiseCODE: \(miseboxUser.miseCODE)")
                .font(.caption)
                .foregroundColor(.purple.opacity(0.8))
        }
        .padding(.top, 13)
        .padding(.leading, 5)
    }
    
    private var leftSide: some View {
        VStack {
            avatarView
            Spacer()
        }
    }
    private var avatarView: some View {
        PhotosPicker(selection: $photoVM.imageSelection, matching: .images) {
            Group {
                if miseboxUser.imageUrl.isEmpty {
                    Image(systemName: "person.crop.circle.badge.plus")
                        .resizable()
                } else {
                    //AvatarView(imageUrl: miseboxUser.imageUrl, width: 60, height: 60, kind: .edit)
                }
            }
            .frame(width: 60, height: 60)
            .contentShape(Rectangle()) // Explicit tap area
        }
    }
}
