//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 10.03.2024.
//

import SwiftUI

struct PersonalInfoView: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        VStack {
            HandleProfileView()
            FullNameProfileView()
            Spacer()
        }
         .navigationBarBackButtonHidden(true)
         .navigationBarItems(leading: Button(action: {
             self.presentationMode.wrappedValue.dismiss()
         }) {
             Text("Custom Back")
         })
     }
 }
