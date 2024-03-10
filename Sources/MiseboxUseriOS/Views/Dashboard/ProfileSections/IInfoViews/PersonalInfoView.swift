//
//  SwiftUIView.swift
//  
//
//  Created by Daniel Watson on 10.03.2024.
//

import SwiftUI

struct PersonalInfoView: View {
    @EnvironmentObject var miseboxUser: MiseboxUserManager.MiseboxUser

    var body: some View {
        VStack {
            HandleProfileView()
            FullNameProfileView()
            Spacer()
        }
        .navigationBarBackButtonHidden(true)
            .navigationBarItems(leading: backButton)
        }
        
        private var backButton: some View {
            Button(action: {}) {
                HStack {
                    Image(systemName: "arrow.left")
                    Text("Back")
                }
            }
            .foregroundColor(.blue) // Customize button appearance
        }
    }
