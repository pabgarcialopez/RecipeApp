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
    
    @Binding var path: NavigationPath

    
    var body: some View {
        
        List {
            // General settings
            Section("General") {
                NavigationLink(value: SettingsDestination.account) {
                    Label("Account", systemImage: "person.crop.circle")
                }
            }
            
            // About & Rate
            Section {
                Button(action: showAboutView) {
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
            FullScreenModal { Text(ABOUT) }
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
    
    func showAboutView() { showingAboutView = true }
    
    func logout() {
        // TODO: Implement logout logic
    }
}

#Preview {
    SettingsView(path: .constant(NavigationPath()))
}

