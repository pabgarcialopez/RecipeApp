//
//  SettingsView.swift
//  RecipeApp
//
//  Created by Pablo García López on 15/8/25.
//

import SwiftUI
import StoreKit

struct SettingsView: View {
    
    @Environment(\.requestReview) var requestReview
    @State private var showingAboutView = false
    
    var body: some View {
        NavigationStack {
            List {
                // General settings
                Section("General") {
                    NavigationLink(destination: AccountView(user: .example)) {
                        Label("Account", systemImage: "person.crop.circle")
                    }
                }
                
                // About & Rate
                Section {
                    Button(action: showAboutModal) {
                        Label("About", systemImage: "info.circle")
                    }
                    
                    Button(action: { requestReview() }) {
                        Label("Rate app", systemImage: "star.bubble")
                    }
                }
                
                Section {
                    logoutButton
                        .listRowBackground(Color.clear)
                        .listRowInsets(EdgeInsets())  // Removes default padding
                }
            }
            .listStyle(.insetGrouped)
            .navigationTitle("Settings")
            .fullScreenCover(isPresented: $showingAboutView) {
                AboutView()
            }
        }
    }
    
    private var logoutButton: some View {
        Button(action: logout) {
            Text("Log out")
                .bold()
                .frame(maxWidth: .infinity)
                .padding()
                .foregroundColor(.red)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.red, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 12))
        }
    }
    
    func showAboutModal() { showingAboutView = true }
    
    func logout() {
        // TODO: Implement logout logic
    }
}

#Preview {
    SettingsView()
}
