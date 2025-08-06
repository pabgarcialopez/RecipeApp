//
//  ProfileView.swift
//  RecipeApp
//
//  Created by Pablo García López on 30/7/25.
//

import SwiftUI

struct ProfileView: View {
    var body: some View {
        
        NavigationStack {
            Text("ProfileView")
                .navigationTitle("Profile")
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        Button {
                            // TODO implement SettingsView
                        } label: {
                            Image(systemName: "gear")
                        }
                    }
                }
        }
    }
}

#Preview {
    ProfileView()
}
