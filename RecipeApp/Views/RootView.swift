//
//  RootView.swift
//  RecipeApp
//
//  Created by Pablo García López on 21/8/25.
//

import SwiftUI

struct RootView: View {
    @StateObject private var auth = AuthViewModel()
    
    var body: some View {
        Group {
            if auth.isAuthenticated {
                ContentView()
            } else {
                AuthenticationView()
            }
        }
        .environmentObject(auth)
    }
}

#Preview {
    RootView()
}
