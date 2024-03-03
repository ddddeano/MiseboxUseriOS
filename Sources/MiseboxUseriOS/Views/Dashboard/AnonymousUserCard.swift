//
// // [MiseboxUseriOS.pkg]  AnonymousUserCard.swift
//
//
//  Created by Daniel Watson on 03.03.2024.
//

import Foundation
import MiseboxiOSGlobal
import SwiftUI

public struct AnonymousUserCard: View {
    @EnvironmentObject var env: Env
    
    @Binding var isAuthenticated: Bool
    public  var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "hare")
                .resizable()
                .scaledToFit()
                .frame(width: 60, height: 60)
                .foregroundColor(.blue)
            
            Text("Welcome to Browse Mode")
                .font(.title2)
                .fontWeight(.semibold)
            
            Text("Feel free to explore. Sign in anytime to unlock more features.")
                .font(.body)
                .foregroundColor(.blue)
                .multilineTextAlignment(.center)
                .padding(.horizontal)
            
            Button(action: {
                isAuthenticated = false
            }) {
                Text("Explore More")
                    .fontWeight(.bold)
                    .foregroundColor(.blue)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(.blue.opacity(0.5))
                    .cornerRadius(10)
                    .shadow(radius: 5)
            }
            .padding(.horizontal)
        }
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(env.appDark.opacity(0.4).edgesIgnoringSafeArea(.all))
    }
}
